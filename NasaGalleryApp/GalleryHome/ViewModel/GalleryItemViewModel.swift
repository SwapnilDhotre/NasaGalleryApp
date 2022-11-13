//
//  GalleryItemViewModel.swift
//  NasaGalleryApp
//
//  Created by Swapnil_Dhotre on 11/12/22.
//

import Foundation

class GalleryItemViewModel {
    
    private var model: GalleryModel
    
    init(model: GalleryModel) {
        self.model = model
    }
    
    func getImageTitle() -> String {
        return self.model.title
    }
    
    func getThumbnailURL() -> String? {
        return self.model.url
    }
    
    func getHDURL() -> String? {
        return self.model.hdurl
    }
    
    func getParsedDate() -> String {
        return self.model.date.formatDateStringTo(format: "dd MMM yyyy")
    }
    
    func getExplanation() -> String? {
        return self.model.explanation
    }
    
    func getDate() -> Date? {
        return self.model.date.convertToDate()
    }
}
