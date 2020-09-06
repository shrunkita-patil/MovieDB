//
//  Helper.swift
//  MovieDB
//
//  Created by Riken Shah on 05/09/20.
//  Copyright © 2020 Shrunkita. All rights reserved.
//

import Foundation
import SystemConfiguration

// MARK: - Enum for HTTP methods
enum HTTPMethod: String {
    case get = "GET"
    case post = "POST"
}

// MARK: - Enum for API end points
enum Endpoint: String {
    case playing = "/now_playing"
    case movieDetail = ""
    case reviews = "/reviews"
    case credits = "/credits"
    case search = "/search/movie"
    case similar = "/similar"
}

// MARK: - Enum for API Errors
enum ApiError: Swift.Error {
    
    case errorMsg(message:String)
    
    var errorDescription: String {
        switch self {
        case let .errorMsg(message):
            return message
        }
    }
}

// MARK: - Enum for API response
enum ResponseError: Error, LocalizedError, Equatable {
    case noData
    case wrongData
    case JSONSerializationFailed
    case noMatchigResults
    
    var errorDescription: String? {
        switch self {
        case .noData:
            return "There is no data available. Please contact support team."// no data available on service fetch
        case .wrongData:
            return "Something went wrong, Please try again later!!!" // We can change this message to any custom and valid error message to user
        case .JSONSerializationFailed:
            return "JSONSerialization Failed, Please check the json data"
        case .noMatchigResults:
            return "No matching results found"
        }
    }
}

// MARK: - Method to check network connection
extension WebService {
    
    // possible states for internet access
    private enum ReachabilityStatus {
        case notReachable
        case reachableViaWWAN
        case reachableViaWiFi
    }
    
    private var currentReachabilityStatus: ReachabilityStatus {
        
        var zeroAddress = sockaddr_in()
        zeroAddress.sin_len = UInt8(MemoryLayout<sockaddr_in>.size)
        zeroAddress.sin_family = sa_family_t(AF_INET)
        
        guard let defaultRouteReachability = withUnsafePointer(to: &zeroAddress, {
            $0.withMemoryRebound(to: sockaddr.self, capacity: 1) {
                SCNetworkReachabilityCreateWithAddress(nil, $0)
            }
        }) else {
            return .notReachable
        }
        
        var flags: SCNetworkReachabilityFlags = []
        if !SCNetworkReachabilityGetFlags(defaultRouteReachability, &flags) {
            return .notReachable
        }
        
        if flags.contains(.reachable) == false {
            // The target host is not reachable.
            return .notReachable
        }
        else if flags.contains(.isWWAN) == true {
            // WWAN connections are OK if the calling application is using the CFNetwork APIs.
            return .reachableViaWWAN
        }
        else if flags.contains(.connectionRequired) == false {
            // If the target host is reachable and no connection is required then we'll assume that you're on Wi-Fi...
            return .reachableViaWiFi
        }
        else if (flags.contains(.connectionOnDemand) == true || flags.contains(.connectionOnTraffic) == true) && flags.contains(.interventionRequired) == false {
            // The connection is on-demand (or on-traffic) if the calling application is using the CFSocketStream or higher APIs and no [user] intervention is needed
            return .reachableViaWiFi
        }
        else {
            return .notReachable
        }
    }
    
    // check for internet access
     func checkForNetworkConnectivity() -> Bool {
        guard self.currentReachabilityStatus != .notReachable else {
            return false
        }
        return true
    }
    
}

