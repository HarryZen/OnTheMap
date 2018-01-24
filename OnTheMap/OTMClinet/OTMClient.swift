//
//  OTMClient.swift
//  OnTheMap
//
//  Created by HarryZen on 2018/1/18.
//  Copyright © 2018年 harry. All rights reserved.
//

import Foundation

class OTMClient: NSObject {
    
    var studentLocation: StudentLocation!
    var studentsLocations: [[String: AnyObject]] = []
    var sessionID: String!
    
    override init(){
        super.init()
    }
    
    var session = URLSession.shared
    
    
    
    func taskForGET(method: String, parameters: [String: AnyObject], completionForGET: @escaping (_ result: AnyObject?, _ error: NSError?) -> Void) -> URLSessionDataTask {
        let urlString = method + escapingParameters(parameters)
        let url = URL(string: urlString)
        print(urlString)
        let request = NSMutableURLRequest(url: url!)
        request.addValue("\(Constants.ParseAppID)", forHTTPHeaderField: "X-Parse-Application-Id")
        request.addValue("\(Constants.RestApiKey)", forHTTPHeaderField: "X-Parse-REST-API-Key")
        
        let task = session.dataTask(with: request as URLRequest){(data, response, error) in
            func sendError(error: String){
                print(error)
                let userInfo = [NSLocalizedDescriptionKey: "\(error)"]
                completionForGET(nil, NSError(domain: "taskForGET", code: 1, userInfo: userInfo))
            }
            
            guard error == nil else {
                sendError(error: "There is an error by your request.")
                return
            }
            
            guard let statusCode = (response as? HTTPURLResponse)?.statusCode, statusCode >= 200 && statusCode <= 299 else {
                sendError(error: "Your request returned a status code other than 2xx!")
                return
            }
            
            guard let data = data else {
                sendError(error: "There is no data by your request")
                return
            }
            
            var parseResult: AnyObject! = nil
            do{
                parseResult = try JSONSerialization.jsonObject(with: data, options: .allowFragments) as AnyObject
            }catch {
                sendError(error: "Can not parse the data")
                return
            }
            
            completionForGET(parseResult, nil)
        }
        task.resume()
        
        return task
    }
    
    func udacityPOSTSession(userName: String, password: String, completionHandle: @escaping (_ success: Bool, _ sessionID: String?, _ error: NSError?) -> Void){
        let urlString = Methods.udacityMethod + escapingParameters([:])
        let url = URL(string: urlString)!
        let request = NSMutableURLRequest(url: url)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = "{\"udacity\": {\"username\": \"\(userName)\", \"password\": \"\(password)\"}}".data(using: String.Encoding.utf8)

        let task = session.dataTask(with: request as URLRequest) {(data, response, error) in
            func sendError(error: String) {
                print(error)
                let userInfo = [NSLocalizedDescriptionKey: "\(error)"]
                completionHandle(false, nil, NSError(domain: "udacityPOSTSession", code: 0, userInfo: userInfo))
            }
            
            guard error == nil  else {
                sendError(error: "There is an error \(error)")
                return
            }
            
            guard let statusCode = (response as? HTTPURLResponse)?.statusCode, statusCode >= 200 && statusCode <= 299 else{
                sendError(error: "Your request returned a status code other 2xx!")
                return
            }
            
            guard let data = data else {
                sendError(error: "There is no data by your request.")
                return
            }
        
            let range = Range(uncheckedBounds: (5, data.count))
            let newData = data.subdata(in: range)
            print(NSString(data: newData, encoding: String.Encoding.utf8.rawValue))
            
            var parseResult: [String: AnyObject]
            do {
                parseResult = try JSONSerialization.jsonObject(with: newData, options: .allowFragments) as! [String: AnyObject]
            }catch {
                sendError(error: "Can not parse the result.")
                return
            }
            
            guard let udacitySession = parseResult["session"] else {
                sendError(error: "There is no session in the result.")
                return
            }
            
            if let sessionID = udacitySession["id"] as? String {
                completionHandle(true, sessionID, nil)
            }else {
                sendError(error: "Can not find the sessionID")
            }
        }
        task.resume()
    }
    
    func parseUrlFromParameters(parameters: [String: AnyObject]?) -> URL{
        var components = URLComponents()
        components.scheme = Constants.ApiScheme
        components.host = Constants.parseApiHost
        components.path = Constants.parseApiPath
        components.queryItems = [URLQueryItem]()
        if let parameters = parameters {
            for (key, value) in parameters {
                let queryItem = URLQueryItem(name: key, value: "\(value)")
                components.queryItems?.append(queryItem)
            }
        }
        return components.url!
    }
    
    func escapingParameters(_ parameters: [String: AnyObject]) -> String {
        if parameters.isEmpty {
            return ""
        }else {
            var keyValuePairs = [String]()
            
            for (key, value) in parameters {
                let strValue = "\(value)"
                
                let escapValue = strValue.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)
                
                keyValuePairs.append("\(key)=\(escapValue!)")
            }
            return "?\(keyValuePairs.joined(separator: "&"))"
        }
    }
    
    
    class func sharedInstance() -> OTMClient {
        struct Singleton {
            static var sharedInstance = OTMClient()
        }
        return Singleton.sharedInstance
    }
}


