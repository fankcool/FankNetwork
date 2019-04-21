//
//  APIRequest.swift
//  Fank
//
//  Created by fank on 2019/4/20.
//  Copyright © 2019年 fank. All rights reserved.
//

import UIKit
import Alamofire

public protocol APIRequestDelegate : NSObjectProtocol {
    func apiRequestCompletion(result: APIResult<JSONDocument>)
}

public typealias CompletionHandler = (_ result: APIResult<JSONDocument>) -> Swift.Void

public typealias SuccessHandler = (_ jsonDocument: JSONDocument) -> Swift.Void
public typealias FailedHandler = (_ error: APIError) -> Swift.Void

extension Optional {
    
    /**
     Runs a block of code if an optional is not nil.
     - Parameter block: Block to run if Optional != nil
     - Parameter wrapped: The wrapped optional.
     */
    func then(_ block: (_ wrapped: Wrapped) throws -> Void) rethrows {
        if let wrapped = self {
            try block(wrapped)
        }
    }
}

public class APIRequest {
    
    /// Enumerations that can be passed to a request options object to modify default request behaviour.
    public enum RequestOption {
        /// The value for the Authorization header. Defaults to self.authorization.
        case header(String, String?)
    }
    
    /// The request created by Alamofire.
    private weak var dataRequest: DataRequest?
    
    private var successHandler : SuccessHandler?
    
    private var failedHandler : FailedHandler?
    
    private weak var requestDelegate : APIRequestDelegate?
    
    public convenience init(url: String, delegate: NSObject) {
        self.init(url: url, method: .get, params: nil, options: nil, delegate: delegate)
    }
    
    /// The document returned by the request. This will not be populated until shortly before completion is called.
//    private(set) var responseJSONDocument: JSONDocument?
    
    public init(url: String, method: HTTPMethod = .get, params: Parameters? = nil, options: [RequestOption]? = nil, delegate: NSObject? = nil) {
        
        if let delegate = delegate as? APIRequestDelegate {
            self.requestDelegate = delegate
        }
        
        // Define variables which may be modified in some way by changing the `options` array.
        var headers: HTTPHeaders = [
            "Accept": "application/vnd.api+json, application/json",
            "Content-Type": "application/vnd.api+json",
            "Device": "iOS",
            "Client": "cool.fank.ios",
            ]
        
        // Loop through all the options and assign their values to the associated variable.
        options?.forEach {
            switch $0 {
            case .header(let headerKey, let headerValue):
                // If the provided value is nil, remove existing header value, if any.
                if let headerValue = headerValue {
                    headers[headerKey] = headerValue
                } else {
                    headers.removeValue(forKey: headerKey)
                }
            } // End switch statement.
        }
        
        self.dataRequest = Alamofire.request(url, method: method, parameters: params, encoding: method == HTTPMethod.get ? URLEncoding.default : JSONEncoding.default, headers: headers).validate(contentType: ["application/json", "application/vnd.api+json"])
    }
    
    @discardableResult public func addCompletionHandler(_ handler: @escaping CompletionHandler) -> Self {
        
        self.dataRequest?.responseJSON { response in
            
            guard let responseJSON = response.result.value as? [String: Any], response.result.isSuccess else {
                
                var status : String?
                
                if let statusCode = response.response?.statusCode {
                    status = statusCode.description
                }
                
                let error = APIError(code: String((response.result.error as NSError?)?.code ?? -1), status: status, message: response.result.error?.localizedDescription ?? "Unknown request error.")
                
                return handler(.error(error))
            }
            
            let responseJSONDocument = JSONDocument(json: responseJSON)
            
            if let jsonApiError = responseJSONDocument.errors?.first {
                return handler(.error(APIError(jsonApiError: jsonApiError)))
            }
            
            if responseJSONDocument.error_code != nil {
                if let statusCode = response.response?.statusCode, statusCode != 200 {
                    if statusCode == 401 || statusCode == 403 {
                        // 退出登录等
                        return
                    }
                    
                    let json = responseJSONDocument.json
                    
                    let error = APIError(code: json["error_code"] as? String ?? "", status: responseJSONDocument.json["status"] as? String ?? "", message: json["message"] as? String ?? "")
                    
                    return handler(.error(error))
                }
            }
            
            handler(.success(responseJSONDocument))
        }
        
        return self
    }
    
    @discardableResult public func addCompletionDelegate() -> Self {
        
        self.dataRequest?.responseJSON { response in
            
            guard let responseJSON = response.result.value as? [String: Any], response.result.isSuccess else {
                
                var status : String?
                
                if let statusCode = response.response?.statusCode {
                    status = statusCode.description
                }
                
                let error = APIError(code: String((response.result.error as NSError?)?.code ?? -1), status: status, message: response.result.error?.localizedDescription ?? "Unknown request error.")
                
                self.requestDelegate?.apiRequestCompletion(result: .error(error))
                
                return
            }
            
            let responseJSONDocument = JSONDocument(json: responseJSON)
            
            if let jsonApiError = responseJSONDocument.errors?.first {
                self.requestDelegate?.apiRequestCompletion(result: .error(APIError(jsonApiError: jsonApiError)))
            }
            
            if responseJSONDocument.error_code != nil {
                if let statusCode = response.response?.statusCode, statusCode != 200 {
                    if statusCode == 401 || statusCode == 403 {
                        // 退出登录等
                        return
                    }
                    
                    let json = responseJSONDocument.json
                    
                    let error = APIError(code: json["error_code"] as? String ?? "", status: responseJSONDocument.json["status"] as? String ?? "", message: json["message"] as? String ?? "")
                    
                    self.requestDelegate?.apiRequestCompletion(result: .error(error))
                }
            }
            
            self.requestDelegate?.apiRequestCompletion(result: .success(responseJSONDocument))
        }
        
        return self
    }
    
    /// Cancels the HTTP request.
    /// - note: If the request has already completed, you may still receive a callback after cancel is called since data parsing happens in a background thread and will still trigger the callback upon completion.
    public func cancel() {
        self.dataRequest?.cancel()
    }
    
    @discardableResult public func success(completion: @escaping SuccessHandler) -> Self {
        self.successHandler = completion
        return self
    }
    
    @discardableResult public func failed(completion: @escaping FailedHandler) -> Self {
        self.failedHandler = completion
        return self
    }
    
    @discardableResult public func addCompletion() -> Self {
        
        self.dataRequest?.responseJSON { response in
            
            guard let responseJSON = response.result.value as? [String: Any], response.result.isSuccess else {
                
                var status : String?
                
                if let statusCode = response.response?.statusCode {
                    status = statusCode.description
                }
                
                let error = APIError(code: String((response.result.error as NSError?)?.code ?? -1), status: status, message: response.result.error?.localizedDescription ?? "Unknown request error.")
                
                return self.failedHandler.then { failed in
                    failed(error)
                }
            }
            
            let responseJSONDocument = JSONDocument(json: responseJSON)
            
            if let jsonApiError = responseJSONDocument.errors?.first {
                
                return self.failedHandler.then { failed in
                    failed(APIError(jsonApiError: jsonApiError))
                }
            }
            
//            if responseJSONDocument.error_code != nil {
//                if let statusCode = response.response?.statusCode, statusCode != 200 {
//                    if statusCode == 401 || statusCode == 403 {
//                        // 退出登录等
//                        return
//                    }
//
//                    let json = responseJSONDocument.json
//
//                    let error = APIError(code: json["error_code"] as? String ?? "", status: responseJSONDocument.json["status"] as? String ?? "", message: json["message"] as? String ?? "")
//
//                    return self.failedHandler.then { failed in
//                        failed(error)
//                    }
//                }
//            }
            
            self.handleErrorCode(response: response, jsonDocument: responseJSONDocument, completion: { error in
                return self.failedHandler.then { failed in
                    failed(error)
                }
            })
            
            self.successHandler.then { success in
                success(responseJSONDocument)
            }
        }
        
        return self
    }
    
    private func handleErrorCode(response: DataResponse<Any>, jsonDocument: JSONDocument, completion: (_ error: APIError) -> Void) {
        
        if jsonDocument.error_code != nil {
            if let statusCode = response.response?.statusCode, statusCode != 200 {
                if statusCode == 401 || statusCode == 403 {
                    // 退出登录等
                    return
                }
                
                let json = jsonDocument.json
                
                let error = APIError(code: json["error_code"] as? String ?? "", status: jsonDocument.json["status"] as? String ?? "", message: json["message"] as? String ?? "")
                
                completion(error)
            }
        }
    }
}

/// Represents JSON API response data in a defined format.
public class JSONDocument {
    /// The JSON data provided to init.
    public let json: [String: Any]
    /**
     Creates a new JSONAPIResource struct from the provided JSON data.
     
     - parameter json: The JSON data to base the struct off of.
     */
    public init(json: [String: Any]) {
        self.json = json
    }
    public convenience init(data: [String: Any]) {
        self.init(json: [
            "data": data,
            ])
    }
    /// json.data
    public var data: [String: Any]? {
        return json["data"] as? [String: Any]
    }
    /// json.meta
    public var meta: [String: Any]? {
        return json["meta"] as? [String: Any]
    }
    /// json.data is NSNull
    public var isResourceUndefined: Bool {
        return json["data"] == nil
    }
    
    /// there is a error code
    public var error_code: Int? {
        guard let error_code = json["error_code"] as? Int else {
            return nil // Top level errors object doesn't exist or is in the incorrect format.
        }
        return error_code
    }
    
    public var errors: [JSONAPIError]? {
        guard let errors = json["errors"] as? [[String: Any]] else {
            return nil // Top level errors object doesn't exist or is in the incorrect format.
        }
        return errors.map { JSONAPIError(error: $0) }
    }
}

/// Represents JSON API errors in a defined format.
public class JSONAPIError {
    /// The JSON data provided to init.
    public let error: [String: Any]
    /**
     Creates a new JSONAPIError struct from the provided JSON data.
     
     - parameter json: The JSON data to base the struct off of.
     */
    public init(error: [String: Any]) {
        self.error = error
    }
    // error.status
    public var status: String? {
        let status = error["status"]
        if let statusInt = status as? Int {
            return String(statusInt)
        }
        return status as? String
    }
    // error.code
    public var code: String? {
        return error["code"] as? String
    }
    // error.title
    public var title: String? {
        return error["title"] as? String
    }
    // error.detail
    public var detail: String? {
        return error["detail"] as? String
    }
    // error.meta
    public var meta: [String: Any]? {
        return error["meta"] as? [String: Any]
    }
}

public enum APIResult<T> {
    case success(T)
    case error(APIError)
}
