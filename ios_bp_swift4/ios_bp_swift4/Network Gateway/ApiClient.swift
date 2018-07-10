//
//  ApiClient.swift
//  ios_bp_swift4
//
//  Created by R@M on 10/07/18.
//  Copyright © 2018 2Fit. All rights reserved.
//

import Foundation
import Alamofire

public typealias SuccessCallback = (_ responseObject: [String: Any], _ responseHeaders: [AnyHashable: Any]) -> Void
public typealias FailureCallback = (_ error: Error) -> Void

class APIClient {
    
    enum HTTPHeader: String {
        case uid = "uid"
        case client = "client"
        case token = "access-token"
        case expiry = "expiry"
        case accept = "Accept"
        case contentType = "Content-Type"
    }
    
    static let baseHeaders: [String: String] = [HTTPHeader.accept.rawValue: "application/json",
                                                HTTPHeader.contentType.rawValue: "application/json"]
    
    fileprivate class func getHeader() -> [String: String]? {
        if let session = SessionManager.currentSession {
            return baseHeaders + [
                HTTPHeader.uid.rawValue: session.uid ?? "",
                HTTPHeader.client.rawValue: session.client ?? "",
                HTTPHeader.token.rawValue: session.accessToken ?? ""
            ]
        }
        return baseHeaders
    }
    
    fileprivate class func getBaseUrl() -> String {
        return Bundle.main.object(forInfoDictionaryKey: "Base URL") as? String ?? ""
    }
    
    class func defaultEncoding(forMethod method: HTTPMethod) -> ParameterEncoding {
        switch method {
        case .post, .put:
            return JSONEncoding.default
        default:
            return URLEncoding.default
        }
    }
    
    class func request(_ method: HTTPMethod, url: String, params: [String: Any]? = nil, paramsEncoding: ParameterEncoding? = nil, success: @escaping SuccessCallback, failure: @escaping FailureCallback) {
        let encoding = paramsEncoding ?? defaultEncoding(forMethod: method)
        let header = APIClient.getHeader()
        let requestUrl = getBaseUrl() + url
        Alamofire.request(requestUrl, method: method, parameters: params, encoding: encoding, headers: header)
            .validate()
            .responseDictionary { response in
                validateResult(ofResponse: response, success: success, failure: failure)
        }
    }
    
    fileprivate class func validateResult(ofResponse response: DataResponse<[String: Any]>,
                                          success: @escaping SuccessCallback,
                                          failure: @escaping FailureCallback) {
        switch response.result {
        case .success(let dictionary):
            if let urlResponse = response.response {
                success(dictionary, urlResponse.allHeaderFields)
            }
            return
        case .failure(let error):
            failure(error)
            if (error as NSError).code == 401 { //Unauthorized user
                //Use this method to logout the user due to auth failure.
                //AppDelegate.shared.unexpectedLogout()
            }
        }
    }
    
    //Handle rails-API-base errors if any
    class func handleCustomError(_ code: Int?, dictionary: [String: Any]) -> NSError? {
        if let messageDict = dictionary["errors"] as? [String: [String]] {
            let errorsList = messageDict[messageDict.keys.first!]!
            return NSError(domain: "\(messageDict.keys.first!) \(errorsList.first!)", code: code ?? 500, userInfo: nil)
        } else if let error = dictionary["error"] as? String {
            return NSError(domain: error, code: code ?? 500, userInfo: nil)
        } else if let errors = dictionary["errors"] as? [String: Any] {
            let errorDesc = errors[errors.keys.first!]!
            return NSError(domain: "\(errors.keys.first!) " + "\(errorDesc)", code: code ?? 500, userInfo: nil)
        } else if dictionary["errors"] != nil || dictionary["error"] != nil {
            return NSError(domain: "Something went wrong. Try again later.", code: code ?? 500, userInfo: nil)
        }
        return nil
    }
    
}

private let emptyDataStatusCodes: Set<Int> = [204, 205]

extension DataRequest {
    public static func responseDictionary() -> DataResponseSerializer<[String: Any]> {
        return DataResponseSerializer { _, response, data, requestError in
            let emptyResponseAllowed = emptyDataStatusCodes.contains(response?.statusCode ?? 0)
            guard let data = data, !data.isEmpty else {
                return emptyResponseAllowed ? .success([:]) : .failure(AFError.responseSerializationFailed(reason: .inputDataNilOrZeroLength))
            }
            var dictionary: [String: Any]?
            var serializationError: NSError?
            do {
                dictionary = try JSONSerialization.jsonObject(with: data, options: .allowFragments) as? [String: Any]
            } catch let exceptionError as NSError {
                serializationError = exceptionError
            }
            //Check for errors in validate() or API
            if let errorOcurred = APIClient.handleCustomError(response?.statusCode, dictionary: dictionary ?? [:]) ?? requestError {
                return .failure(errorOcurred)
            }
            //Check for JSON serialization errors if any data received
            return serializationError == nil ? .success(dictionary ?? [:]) : .failure(serializationError!)
        }
    }
    
    @discardableResult
    func responseDictionary(
        _ queue: DispatchQueue? = nil,
        completionHandler: @escaping (DataResponse<[String: Any]>) -> Void) -> Self {
        return response(
            queue: queue,
            responseSerializer: DataRequest.responseDictionary(),
            completionHandler: completionHandler
        )
    }
}
