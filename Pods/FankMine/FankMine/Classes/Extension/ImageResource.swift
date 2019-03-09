//
//  ImageResource.swift
//  FankMine
//
//  Created by fank on 2019/3/6.
//  Copyright © 2019年 fank. All rights reserved.
//

import UIKit

enum ImageType : String {
    case JPG = ".jpg"
    case PNG = ".png"
    
    var value : String {
        return self.rawValue
    }
}

public class ImageResource {
    
    public class func loadImage(name:String) -> UIImage {
        var path : String?
        let currentBundle = Bundle(for: self)
        if name.contains(".") {
            path = currentBundle.path(forResource: name, ofType: nil)
        } else {
            if let jpgPath = currentBundle.path(forResource: name + ImageType.JPG.value, ofType: nil) {
                path = jpgPath
            } else if let pngPath = currentBundle.path(forResource: name + ImageType.PNG.value, ofType: nil) {
                path = pngPath
            }
        }
        return UIImage(contentsOfFile: path!)!
    }
}
