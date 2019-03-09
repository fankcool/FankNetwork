//
//  Target_FankMine.swift
//  FankMine
//
//  Created by fank on 2019/3/9.
//  Copyright © 2019年 fank. All rights reserved.
//

import UIKit

class Target_FankMine: NSObject {
    
    func Action_MineViewController(_ params:[AnyHashable:Any]) -> UIViewController {
        if let callback = params["callback"] as? (String) -> Void {
            callback("success")
        }
        
        return MineViewController.loadFromStoryboard()
    }
}
