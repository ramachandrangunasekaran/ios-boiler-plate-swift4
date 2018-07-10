//
//  HomeApi.swift
//  ios_bp_swift4
//
//  Created by R@M on 10/07/18.
//  Copyright © 2018 2Fit. All rights reserved.
//

import Foundation

class HomeAPI {
    
    /*
     //Example func with completion handler for Login/Post Method.
     
     fileprivate static let usersUrl = "/users/"
     fileprivate static let currentUserUrl = "/user/"
     
     class func login(_ email: String, password: String, success: @escaping () -> Void, failure: @escaping (_ error: Error) -> Void) {
     let url = usersUrl + "sign_in"
     let parameters = [
     "user": [
     "email": email,
     "password": password
     ]
     ]
     APIClient.request(.post, url: url, params: parameters, success: { response, headers in
     HomeAPI.saveUserSession(fromResponse: response, headers: headers)
     success()
     }, failure: { error in
     failure(error)
     })
     }
     
     class func saveUserSession(fromResponse response: [String: Any], headers: [AnyHashable: Any]) {
     UserDataManager.currentUser = try? JSONDecoder().decode(User.self, from: response["user"] as? [String: Any] ?? [:])
     if let headers = headers as? [String: Any] {
     SessionManager.currentSession = Session(headers: headers)
     }
     }
     
     class func logout(_ success: @escaping () -> Void, failure: @escaping (_ error: Error) -> Void) {
     let url = usersUrl + "sign_out"
     APIClient.request(.delete, url: url, success: {_, _ in
     UserDataManager.deleteUser()
     SessionManager.deleteSession()
     success()
     }, failure: { error in
     failure(error)
     })
     }
     
     */
    
    fileprivate static let get_my_ip = "/json"
    
    class func getMyIP(success: @escaping (_ data: [String: Any]) -> Void, failure: @escaping (_ error: Error) -> Void) {
        APIClient.request(.get, url: get_my_ip, success: { (response, _) in
            success(response)
        }) { (error) in
            failure(error)
        }
    }
    
}
