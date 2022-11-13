//
//  GalleryModel.swift
//  NasaGalleryApp
//
//  Created by Swapnil_Dhotre on 11/12/22.
//

import Foundation

struct GalleryModel: Codable {
    var title: String
    var url: String?
    var hdurl: String?
    var mediaType: String
    var serviceVersion: String?
    var explanation: String?
    var date: String
    var copyright: String?
    
    enum CodingKeys: String, CodingKey {
        case title, url, hdurl, explanation, date, copyright
        case mediaType = "media_type"
        case serviceVersion = "service_version"
    }
}
