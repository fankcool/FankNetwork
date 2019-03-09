//
//  Target_FankNetwork.swift
//  FankNetwork
//
//  Created by fank on 2019/3/10.
//  Copyright © 2019年 fank. All rights reserved.
//

import UIKit
import CTMediator

let networkTarget = "FankNetwork"
let networkAction = "NetworkViewController"

let networkPOSTAction = "NetworkPostViewController"

public extension CTMediator {
    
    public func showNetworkViewController(callback: @escaping (String) -> Void) -> UIViewController? {
        // kCTMediatorParamsKeySwiftTargetModuleName为模块名称，swift里必须写
        let params = ["callback":callback,
                      kCTMediatorParamsKeySwiftTargetModuleName:"FankNetwork"] as [AnyHashable : Any]
        if let vc = self.performTarget(networkTarget, action: networkAction, params: params, shouldCacheTarget: false) as? UIViewController {
            return vc
        }
        return nil
    }
    
    public func showNetworkPostViewController(callback: @escaping (String) -> Void) -> UIViewController? {
        // kCTMediatorParamsKeySwiftTargetModuleName为模块名称，swift里必须写
        let params = ["callback":callback,
                      kCTMediatorParamsKeySwiftTargetModuleName:"FankNetwork"] as [AnyHashable : Any]
        if let vc = self.performTarget(networkTarget, action: networkPOSTAction, params: params, shouldCacheTarget: false) as? UIViewController {
            return vc
        }
        return nil
    }
}

@objc class Target_FankNetwork: NSObject {
    
    @objc func Action_NetworkViewController(_ params:[AnyHashable:Any]) -> UIViewController {
        if let callback = params["callback"] as? (String) -> Void {
            callback("success")
        }
        
        let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "NetworkViewController") as! NetworkViewController
        
        return vc
    }
    
    @objc func Action_NetworkPostViewController(_ params:[AnyHashable:Any]) -> UIViewController {
        if let callback = params["callback"] as? (String) -> Void {
            callback("success")
        }
        
        let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "NetworkPostViewController") as! NetworkPostViewController
        
        return vc
    }
}
