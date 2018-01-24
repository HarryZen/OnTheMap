//
//  OTMConvenience.swift
//  OnTheMap
//
//  Created by HarryZen on 2018/1/19.
//  Copyright © 2018年 harry. All rights reserved.
//

import Foundation

extension OTMClient { 
    
    func getStudentLocation(_ parameters: [String: AnyObject], completionHandle: @escaping ((_ success: Bool, _ studentsLocations: [[String: AnyObject]]?, _ error: NSError?) -> Void)) {
        taskForGET(method: Methods.parseMethod , parameters: parameters){(result, error) in
            if error != nil {
                print(error)
                completionHandle(false, nil, error)
            }else {
                if let students = result!["results"] as? [[String: AnyObject]] {
                    for student in students {
                        self.studentsLocations.append(student)
                    }
                    completionHandle(true, self.studentsLocations, nil)
                }else {
                    completionHandle(false, nil, NSError(domain: "getStudentLocation", code: 1, userInfo: [NSLocalizedDescriptionKey: "Can not get the student location."]))
                }
            }
        }
    }
    
}
