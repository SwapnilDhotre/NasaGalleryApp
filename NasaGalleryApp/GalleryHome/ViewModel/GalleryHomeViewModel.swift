//
//  GalleryHomeViewModel.swift
//  NasaGalleryApp
//
//  Created by Swapnil_Dhotre on 11/12/22.
//

import Foundation
import Combine

class GalleryHomeViewModel {
    var galleryData: Observable<[GalleryItemViewModel]>
    var galleryDataLoading: Observable<Bool?>
    var galleryDataFetchError: Observable<Error?>
    
    private var networkService: NetworkService
    private var cancellable = Set<AnyCancellable>()
    
    init(networkService: NetworkService) {
        self.networkService = networkService
        
        self.galleryData = Observable<[GalleryItemViewModel]>([])
        self.galleryDataLoading = Observable<Bool?>(nil)
        self.galleryDataFetchError = Observable<Error?>(nil)
    }
    
    // Get gallery data api
    func getGalleryData() {
        self.galleryDataLoading.value = true
        
        networkService.getGalleryData()
            .sink { completion in
                self.galleryDataLoading.value = false
                
                switch completion {
                case .failure(let error):
                    print("Error occurred: \(error.localizedDescription)")
                    self.galleryData.value = []
                    self.galleryDataFetchError.value = error
                case .finished:
                    print("Completed")
                }
            } receiveValue: { [weak self] galleryData in
                var viewModelData: [GalleryItemViewModel] = []
                galleryData.forEach { model in
                    viewModelData.append(GalleryItemViewModel(model: model))
                }
                
                // Sort data to view latest first
                let sortedViewModel = viewModelData.sorted { $0.getDate()! > $1.getDate()! }
                self?.galleryData.value = sortedViewModel
            }
            .store(in: &self.cancellable)
    }
}
