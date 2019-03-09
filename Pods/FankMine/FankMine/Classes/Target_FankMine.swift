//
//  Target_FankMine.swift
//  FankMine
//
//  Created by fank on 2019/3/9.
//  Copyright © 2019年 fank. All rights reserved.
//

import UIKit
import CTMediator

let target = "FankMine"
let action = "MineViewController"

public extension CTMediator {
    
    public func showMineViewController(callback: @escaping (String) -> Void) -> UIViewController? {
        let params = ["callback":callback,
                      kCTMediatorParamsKeySwiftTargetModuleName:target] as [AnyHashable : Any]
        if let vc = self.performTarget(target, action: action, params: params, shouldCacheTarget: false) as? UIViewController {
            return vc
        }
        return nil
    }
}

@objc class Target_FankMine: NSObject {
    
    @objc func Action_MineViewController(_ params:[AnyHashable:Any]) -> UIViewController {
        if let callback = params["callback"] as? (String) -> Void {
            callback("success")
        }
        
        return MineViewController.loadFromStoryboard()!
    }
}
