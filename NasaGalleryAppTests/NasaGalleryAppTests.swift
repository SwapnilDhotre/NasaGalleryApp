//
//  NasaGalleryAppTests.swift
//  NasaGalleryAppTests
//
//  Created by Swapnil_Dhotre on 11/13/22.
//

import XCTest
import Combine
@testable import NasaGalleryApp

class NasaGalleryAppTests: XCTestCase {
    
    private var sut: GalleryHomeViewModel!
    private var networkService: MockNetworkService!
    private var mockViewListener: MockViewListener!

    override func setUpWithError() throws {
        networkService = MockNetworkService()
        sut = GalleryHomeViewModel(networkService: networkService)
        
        mockViewListener = MockViewListener(viewModel: sut)
        
        try super.setUpWithError()
    }

    override func tearDownWithError() throws {
        mockViewListener = nil
        sut = nil
        networkService = nil
        
        try super.tearDownWithError()
    }

    func testUpdateData_onAPISuccess() {
        // Given
        let model = GalleryModel(title: "San Francisco Night", url: "http://sample.com/sample1.jpg", hdurl: nil, mediaType: "image", serviceVersion: "v1", explanation: "Great place to enjoy night.", date: "2020-12-26", copyright: "Mahesh Sharma")
        networkService.mockResponse = .success([model])
        
        // When
        sut.getGalleryData()
        
        // Then
        XCTAssertEqual(mockViewListener.data.count, 1)
        XCTAssertEqual(mockViewListener.data.first!.getImageTitle(), "San Francisco Night")
        XCTAssertEqual(mockViewListener.data.first!.getThumbnailURL(), "http://sample.com/sample1.jpg")
        XCTAssertEqual(mockViewListener.data.first!.getHDURL(), nil)
        XCTAssertEqual(mockViewListener.data.first!.getExplanation(), "Great place to enjoy night.")
        XCTAssertEqual(mockViewListener.data.first!.getParsedDate(), "26 Dec 2020")
    }
    
    func testUpdateData_onAPIFailure() {
        // Given
        networkService.mockResponse = .failure(NetworkError.responseError)
        
        // When
        sut.getGalleryData()
        
        // Then
        XCTAssertEqual(mockViewListener.data.count, 0)
        XCTAssertNotNil(mockViewListener.error)
        XCTAssertTrue(mockViewListener.error is NetworkError)
        XCTAssertEqual(mockViewListener.error as! NetworkError, NetworkError.responseError)
    }
}

class MockNetworkService: NetworkService {
    
    var mockResponse: Result<[GalleryModel], Error>?
    private var cancellables = Set<AnyCancellable>()
    
    func getGalleryData() -> Future<[GalleryModel], Error> {
        return Future<[GalleryModel], Error> { [weak self] promise in
            promise(self!.mockResponse!)
        }
    }
}

class MockViewListener {
    var data: [GalleryItemViewModel] = []
    var error: Error?
    
    init(viewModel: GalleryHomeViewModel) {
        viewModel.galleryData.bind { data in
            self.data = data
        }
        
        viewModel.galleryDataFetchError.bind { error in
            self.error = error
        }
    }
}
