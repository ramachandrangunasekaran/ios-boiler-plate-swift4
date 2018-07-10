//
//  BPHomeViewModel.swift
//  ios_bp_swift4
//
//  Created by R@M on 10/07/18.
//  Copyright © 2018 2Fit. All rights reserved.
//

import Foundation

struct BPHomeViewModel {
    
    var ipAddress: Wrapper<[String: Any]> = Wrapper([: ])
    
    func profile(_ success: @escaping  () -> Void, failure: @escaping (_ error: Error) -> Void) {
        HomeAPI.getMyIP(success: { (value) in
            self.ipAddress.value = value
            success()
        }) { (error) in
            failure(error)
        }
    }
    
}
