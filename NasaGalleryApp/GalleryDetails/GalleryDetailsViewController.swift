//
//  GalleryDetailsViewController.swift
//  NasaGalleryApp
//
//  Created by Swapnil_Dhotre on 11/12/22.
//

import UIKit
import SDWebImage

class GalleryDetailsViewController: UIViewController {

    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var lblDate: UILabel!
    @IBOutlet weak var galleryImage: UIImageView!
    
    @IBOutlet weak var lblDescription: UILabel!
    @IBOutlet weak var lblOverviewTitle: UILabel!
    @IBOutlet weak var overviewView: UIView!
    
    @IBOutlet weak var imageHeightEqualityConstraint: NSLayoutConstraint!
    var viewModel: GalleryItemViewModel?
    
    static func create(viewModel: GalleryItemViewModel) -> GalleryDetailsViewController {
        let controller = GalleryDetailsViewController()
        controller.viewModel = viewModel
        
        return controller
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.updateData()
        self.clearNavigationBar(withBackButton: true, selector: #selector(self.backButtonTapped))
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.overviewView.layer.cornerRadius = 20
        self.overviewView.layer.masksToBounds = true
    }
    
    // Updates UI on details screen
    func updateData() {
        if let viewModel = viewModel {
            self.lblTitle.text = viewModel.getImageTitle()
            self.lblDate.text = viewModel.getParsedDate()
            self.lblDescription.text = viewModel.getExplanation()
            
            self.galleryImage.sd_imageIndicator = SDWebImageActivityIndicator.whiteLarge
            self.galleryImage.sd_setImage(with: URL(string: viewModel.getHDURL() ?? "")) { image, error, _, _ in
                if error != nil {
                    self.galleryImage.image = UIImage(named: "no_image_found")
                }
            }
        }
    }
    
    @objc func backButtonTapped() {
        self.navigationController?.popViewController(animated: true)
    }

    @IBAction func overviewTapped(_ sender: UIButton) {
    }
}
