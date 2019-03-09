//
//  NetworkViewController.swift
//  FankNetwork
//
//  Created by fank on 2019/3/10.
//  Copyright © 2019年 fank. All rights reserved.
//

import UIKit
import CTMediator
import FankMine

typealias Closure = (String) -> Void

class NetworkViewController: UIViewController {
    
    var userId : String?
    
    var closure : Closure?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "FankNetwork"
        
        print("NetworkViewController - \(String(describing: userId))")
        
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.add, target: self, action: #selector(pushToOtherVc))
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        if let closure = closure {
            closure("NetworkViewController - viewWillDisappear")
        }
    }
    
    @objc func pushToOtherVc(_ sender: UIBarButtonItem) {
        
        let vc = CTMediator.sharedInstance().showMineViewController { result in
            print(result)
        }
        self.navigationController?.pushViewController(vc!, animated: true)
    }
}
