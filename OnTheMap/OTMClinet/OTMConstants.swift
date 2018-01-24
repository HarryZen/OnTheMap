//
//  OTMConstants.swift
//  OnTheMap
//
//  Created by HarryZen on 2018/1/18.
//  Copyright © 2018年 harry. All rights reserved.
//

import Foundation

extension OTMClient {
    struct Constants {
        static let ParseAppID = "QrX47CA9cyuGewLdsL7o5Eb8iug6Em8ye0dnAbIr"
        static let RestApiKey = "QuWThTdiRmTux3YaDseUSEpUKo7aBYM737yKd4gY"
        static let ApiScheme = "https"
        static let parseApiHost = "parse.udacity.com"
        static let parseApiPath = "parse/classes/StudentLoation"
        
        static let udacityApiHost = "www.udacity.com"
        static let udacityApiPath = "api/session"
        
        static let udacityName = "358067541@qq.com"
        static let udacityPassword = "zh850128"
        
        static let locationCreatedAt = "createdAt"
        static let locationFirstName = "firstName"
        static let locationLastName = "lastName"
        static let locationLatitude = "latitude"
        static let locationLongtitude = "longtitude"
        static let locationMapString = "mapString"
        static let locationMediaURl = "mediaURL"
    }
    
    struct Methods {
        static let parseMethod = "https://parse.udacity.com/parse/classes/StudentLocation"
        static let udacityMethod = "https://www.udacity.com/api/session"
    }
    
    struct StudentLocation {
        var createdAt: String
        var firstName: String
        var lastName: String
        var latitude: Double
        var longtitude: Double
        var mapString: String
        var mediaURL: String
    }

}

