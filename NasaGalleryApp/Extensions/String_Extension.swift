//
//  String_Extension.swift
//  NasaGalleryApp
//
//  Created by Swapnil_Dhotre on 11/12/22.
//

import Foundation

extension String {
    // Convert string to formatted date
    func formatDateStringTo(format: String) -> String {
        let inputFormatter = DateFormatter()
        inputFormatter.dateFormat = "yyyy-MM-dd"
        
        let showDate = inputFormatter.date(from: self)
        inputFormatter.dateFormat = format
        
        let resultString = inputFormatter.string(from: showDate!)
        return resultString
    }
    
    // Convert string to date
    func convertToDate() -> Date? {
        let inputFormatter = DateFormatter()
        inputFormatter.dateFormat = "yyyy-MM-dd"
        
        return inputFormatter.date(from: self)
    }
}
