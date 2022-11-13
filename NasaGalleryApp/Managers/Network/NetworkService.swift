//
//  NetworkManagerService.swift
//  NasaGalleryApp
//
//  Created by Swapnil_Dhotre on 11/13/22.
//

import Foundation
import Combine

protocol NetworkService {
    func getGalleryData() -> Future<[GalleryModel], Error>
}
