//
//  Created by fank on 2019/3/6.
//  Copyright © 2019年 fank. All rights reserved.
//

import UIKit

@IBDesignable public class MakeUIViewGreatAgain: UIView {
    @IBInspectable var cornerRadius: CGFloat {
        get {
            return layer.cornerRadius
        }
        set {
            layer.cornerRadius = newValue
            layer.masksToBounds = newValue > 0
        }
    }
    
    @IBInspectable var shadowRadius: CGFloat {
        get {
            return layer.shadowRadius
        }
        set {
            layer.shadowOffset = CGSize(width: 0, height: 0)
            layer.shadowColor = UIColor.black.cgColor
            layer.shadowOpacity = 0.4
            layer.shadowRadius = shadowRadius
        }
    }
    
    @IBInspectable var interfaceBuilderBackgroundColor: UIColor?
    open override func prepareForInterfaceBuilder() {
        super.prepareForInterfaceBuilder()
        self.backgroundColor = self.interfaceBuilderBackgroundColor ?? self.backgroundColor
    }
}

@IBDesignable public class MakeUIImageViewGreatAgain: UIImageView {
    
    // 存储属性跟计算属性效果一样，少些个get
//    @IBInspectable var name: String = "" {
//        didSet {
//            self.image = ImageResource.loadImage(name: name)
//        }
//    }
    
    @IBInspectable var name: String {
        get {
            return "defalut image"
        }
        set {
            self.image = ImageResource.loadImage(name: newValue)
        }
    }
    
    @IBInspectable var cornerRadius: CGFloat {
        get {
            return layer.cornerRadius
        }
        set {
            layer.cornerRadius = newValue
            layer.masksToBounds = newValue > 0
        }
    }
    
    @IBInspectable var shadowRadius: CGFloat {
        get {
            return layer.shadowRadius
        }
        set {
            layer.shadowOffset = CGSize(width: 0, height: 0)
            layer.shadowColor = UIColor.black.cgColor
            layer.shadowOpacity = 0.4
            layer.shadowRadius = shadowRadius
        }
    }
    
    @IBInspectable var interfaceBuilderBackgroundColor: UIColor?
    open override func prepareForInterfaceBuilder() {
        super.prepareForInterfaceBuilder()
        self.backgroundColor = self.interfaceBuilderBackgroundColor ?? self.backgroundColor
    }
}
