//
//  NasaGalleryAppUITests.swift
//  NasaGalleryAppUITests
//
//  Created by Swapnil_Dhotre on 11/13/22.
//

import XCTest

class NasaGalleryAppUITests: XCTestCase {

    override func setUpWithError() throws {
        continueAfterFailure = false
    }

    func testFlowOfApp() throws {
        let app = XCUIApplication()
        app.launch()
        
        // Check if user starts from home screen
        XCTAssert(app.staticTexts["Gallery Home"].exists)
       
        // Get access to collection view
        let collectionView = app.collectionViews["home_collectionView"]
        let count = collectionView.cells.count
        
        XCTAssertTrue(count > 0)
        
        // Tap on cell to navigate
        collectionView.cells.element(boundBy: 0).tap()
        
        // Get access to details swipe collection view
        let detailsCollectionView = app.collectionViews["gallery_details_collectionView"]
        let cell = detailsCollectionView.cells.element(boundBy: 0)
        
        // Check title label to match existing records
        let titleLabel = app.staticTexts["lbl_title"]
        XCTAssertEqual("M33: The Triangulum Galaxy", titleLabel.label)
        
        let dateLabel = app.staticTexts["lbl_date"]
        XCTAssertEqual("31 Dec 2019", dateLabel.label)
        
        // Check description
        let btnCheckDesc = app.buttons["btn_expand"]
        btnCheckDesc.tap()
        
        let galleryImage = app.images["gallery_image"]
        let frameHeight = galleryImage.frame.height
        
        XCTAssertLessThan(frameHeight, 400)
        
        // Tap on image to hide desc
        let btnImageTap = app.buttons["btn_image_tap"]
        btnImageTap.tap()
        let expandedFrameHeight = galleryImage.frame.height
        XCTAssertGreaterThan(expandedFrameHeight, 500)
        
        let backButton = app.buttons["btn_back"]
        backButton.tap()
                
        // After pop check if user is on home screen
        XCTAssert(app.staticTexts["Gallery Home"].exists)
    }

    func testLaunchPerformance() throws {
        if #available(macOS 10.15, iOS 13.0, tvOS 13.0, watchOS 7.0, *) {
            // This measures how long it takes to launch your application.
            measure(metrics: [XCTApplicationLaunchMetric()]) {
                XCUIApplication().launch()
            }
        }
    }
}
