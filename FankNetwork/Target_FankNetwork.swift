//
//  Target_FankNetwork.swift
//  FankNetwork
//
//  Created by fank on 2019/3/10.
//  Copyright © 2019年 fank. All rights reserved.
//

import UIKit
import CTMediator

let NetworkTarget = "FankNetwork"
let NetworkAction = "NetworkViewController"

let NetworkPOSTAction = "NetworkPostViewController"

public extension CTMediator {
    
    public func showNetworkViewController(userId: String, callback: @escaping (String) -> Void) -> UIViewController? {
        // kCTMediatorParamsKeySwiftTargetModuleName为模块名称，swift里必须写
        let params = ["userId":userId,
                      "callback":callback,
                      kCTMediatorParamsKeySwiftTargetModuleName:NetworkTarget] as [AnyHashable : Any]
        if let vc = self.performTarget(NetworkTarget, action: NetworkAction, params: params, shouldCacheTarget: false) as? UIViewController {
            return vc
        }
        return nil
    }
    
    public func showNetworkPostViewController(callback: @escaping (String) -> Void) -> UIViewController? {
        // kCTMediatorParamsKeySwiftTargetModuleName为模块名称，swift里必须写
        let params = ["callback":callback,
                      kCTMediatorParamsKeySwiftTargetModuleName:NetworkTarget] as [AnyHashable : Any]
        if let vc = self.performTarget(NetworkTarget, action: NetworkPOSTAction, params: params, shouldCacheTarget: false) as? UIViewController {
            return vc
        }
        return nil
    }
}

@objc class Target_FankNetwork: NSObject {
    
    @objc func Action_NetworkViewController(_ params:[AnyHashable:Any]) -> UIViewController {
        
        if let vc = NetworkViewController.loadFromStoryboard(name: "Main") {
            
            vc.userId = params["userId"] as? String
            
            // 通过两层闭包回传目标页面到上一页的值
            vc.closure = { result in
                if let callback = params["callback"] as? (String) -> Void {
                    callback(result)
                }
            }
            
            return vc
        }
        
        return UIViewController() // 此处感觉可以返回一个通用的错误提示控制器，如果有错误能让接受返回的地方更加明了
    }
    
    @objc func Action_NetworkPostViewController(_ params:[AnyHashable:Any]) -> UIViewController {
        
        if let callback = params["callback"] as? (String) -> Void {
            callback("success")
        }
        
        if let vc = NetworkPostViewController.loadFromStoryboard(name: "Main") {
            return vc
        }
        
        return UIViewController()
    }
}
