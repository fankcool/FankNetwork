//
//  FankMine_Extension.swift
//  FankMine_Extension
//
//  Created by fank on 2019/3/9.
//  Copyright © 2019年 fank. All rights reserved.
//

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
