//
//  NetworkError.swift
//  NasaGalleryApp
//
//  Created by Swapnil_Dhotre on 11/12/22.
//

import Foundation

// API request error
enum NetworkError: Error {
    // Throws when url is invalid
    case invalidURL
    
    // Response returned is invalid
    case responseError
    
    // If here then need to find exact case why this error occurred
    case unknownError
}

// For each network error return some custom error string
extension NetworkError: CustomStringConvertible {
    var description: String {
        switch self {
        case .invalidURL:
            return "Invalid request please try again."
        case .responseError:
            return "Response is not proper from server."
        case .unknownError:
            return "Unknown Error"
        }
    }
}
