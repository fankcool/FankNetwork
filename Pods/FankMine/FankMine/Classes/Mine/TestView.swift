//
//  TestView.swift
//  FankMine
//
//  Created by fank on 2019/3/6.
//  Copyright © 2019年 fank. All rights reserved.
//

import UIKit

public class TestView: UIView {

    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.initView()
    }
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        self.initView()
    }
    
    func initView() {
        print("\(self) \(#function)")
    }
}
