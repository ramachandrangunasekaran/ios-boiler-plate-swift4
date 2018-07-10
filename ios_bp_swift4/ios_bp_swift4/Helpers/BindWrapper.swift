//
//  BindWrapper.swift
//  ios_bp_swift4
//
//  Created by R@M on 10/07/18.
//  Copyright © 2018 2Fit. All rights reserved.
//

import Foundation

class Wrapper<T> {
    typealias Listener = (T) -> Void
    var listener: Listener?
    
    var value: T {
        didSet {
            listener?(value)
        }
    }
    
    init(_ value: T) {
        self.value = value
    }
    
    func bind(listener: Listener?) {
        self.listener = listener
        listener?(value)
    }
}
