//
//  Extension.swift
//  FankExtension
//
//  Created by fank on 2019/3/10.
//  Copyright © 2019年 fank. All rights reserved.
//

import Foundation

extension Optional {
    
    /**
     Runs a block of code if an optional is not nil.
     - Parameter block: Block to run if Optional != nil
     - Parameter wrapped: The wrapped optional.
     */
    func then(_ block: (_ wrapped: Wrapped) throws -> Void) rethrows {
        if let wrapped = self {
            try block(wrapped)
        }
    }
}

extension Array where Element: Equatable {
    mutating func remove(_ object: Element) {
        if let index = index(of: object) {
            remove(at: index)
        }
    }
}
