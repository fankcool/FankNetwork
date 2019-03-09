//
//  MineViewController.swift
//  FankMine
//
//  Created by fank on 2019/3/7.
//  Copyright © 2019年 fank. All rights reserved.
//

import UIKit

public class MineViewController: UIViewController {
    
    public let value = "what's value ?"

    override public func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "FankMine"
    }
    
    public class func doSomething() {
        print("*** doSomething")
    }
    
}
