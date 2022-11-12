//
//  GalleryHomeViewController.swift
//  NasaGalleryApp
//
//  Created by Swapnil_Dhotre on 11/12/22.
//

import UIKit

class GalleryHomeViewController: UIViewController {
    var viewModel: GalleryHomeViewModel?
    
    static func create() -> GalleryHomeViewController {
        let controller = GalleryHomeViewController()
        controller.viewModel = GalleryHomeViewModel()
        
        return controller
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
}
