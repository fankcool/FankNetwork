//
//  UIViewExtension.swift
//  FankExtension
//
//  Created by fank on 2019/3/10.
//  Copyright © 2019年 fank. All rights reserved.
//

import UIKit

public protocol StoryboardLoadable { }

public extension StoryboardLoadable {
    
    // 此处感觉返回个可选值不方便，但是不反悔可选值又有可能因为没找到控制器而崩溃，如何权衡？？
    static func loadFromStoryboard(name: String = "\(Self.self)") -> Self? {
        
        var sef : Self?
        
        let currentBundle = Bundle(for: self as! AnyClass)
        
        let storyboard = UIStoryboard(name: name, bundle: currentBundle)
        
        // 必须加后面的isKindOf判断，不然可能把sb里的初始化控制器当成了目标控制器返回
        if let vc = storyboard.instantiateInitialViewController(), vc.isKind(of: self as! AnyClass) {
            sef = vc as? Self
        } else {
            sef = storyboard.instantiateViewController(withIdentifier: "\(String(describing: self))") as? Self
        }
        
        return sef
    }
}

extension UIViewController : StoryboardLoadable { }

public protocol NibLoadable { }

public extension NibLoadable {
    static func loadFromNib() -> Self {
        let currentBundle = Bundle(for: self as! AnyClass)
        return currentBundle.loadNibNamed("\(self)", owner: nil, options: nil)?.first as! Self
    }
}

extension UIView : NibLoadable {
    public var origin: CGPoint {
        get {
            return self.frame.origin
        }
        set(newOrigin) {
            var frame = self.frame
            frame.origin = newOrigin
            self.frame = frame
        }
    }
    
    public var x: CGFloat {
        get {
            return self.frame.origin.x
        }
        set(newX) {
            var frame = self.frame
            frame.origin.x = newX
            self.frame = frame
        }
    }
    
    public var y: CGFloat {
        get {
            return self.frame.origin.y
        }
        
        set(newY) {
            var frame = self.frame
            frame.origin.y = newY
            self.frame = frame
        }
    }
    
    public var size: CGSize {
        get {
            return self.frame.size
        }
        set(newSize) {
            var frame = self.frame
            frame.size = newSize
            self.frame = frame
        }
    }
    
    public var width: CGFloat {
        get {
            return self.frame.size.width
        }
        
        set(newWidth) {
            var frame = self.frame
            frame.size.width = newWidth
            self.frame = frame
        }
    }
    
    public var height: CGFloat {
        get {
            return self.frame.size.height
        }
        
        set(newHeight) {
            var frame = self.frame
            frame.size.height = newHeight
            self.frame = frame
        }
    }
    
    public var maxX: CGFloat {
        get {
            return self.x + self.width
        }
    }
    
    public var maxY: CGFloat {
        get {
            return self.y + self.height
        }
    }
    
    public var minX: CGFloat {
        get {
            return self.x
        }
    }
    
    public var minY: CGFloat {
        get {
            return self.y
        }
    }
    
    public var centerX: CGFloat {
        get {
            return self.center.x
        }
        
        set(newCenterX) {
            var center = self.center
            center.x = newCenterX
            self.center = center
        }
    }
    
    public var centerY: CGFloat {
        get {
            return self.center.y
        }
        
        set(newCenterY) {
            var center = self.center
            center.y = newCenterY
            self.center = center
        }
    }
}
