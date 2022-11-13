//
//  SwipeCollectionViewCell.swift
//  NasaGalleryApp
//
//  Created by Swapnil_Dhotre on 11/13/22.
//

import UIKit
import SDWebImage

class SwipeCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var lblDate: UILabel!
    @IBOutlet weak var galleryImage: UIImageView!
    
    @IBOutlet weak var lblDescription: UILabel!
    @IBOutlet weak var lblOverviewTitle: UILabel!
    @IBOutlet weak var overviewView: UIView!
    @IBOutlet weak var textContainerView: UIView!
    @IBOutlet weak var scrollView: UIScrollView!
    
    @IBOutlet weak var imageHalfHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var imageHeightEqualityConstraint: NSLayoutConstraint!

    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.styleUI()
    }
    
    func styleUI() {
        self.scrollView.backgroundColor = .clear
        self.textContainerView.backgroundColor = .clear
    }
    
    // Update labels of the cell
    func setData(viewModel: GalleryItemViewModel) {
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
    
    @IBAction func tapOnImage(_ sender: UIButton) {
        self.imageHalfHeightConstraint.priority = UILayoutPriority(800)
        UIView.animate(withDuration: 1.0) {
            self.lblOverviewTitle.textColor = .white
            self.lblDescription.textColor = .white
            self.overviewView.backgroundColor = .clear
            
            self.contentView.layoutIfNeeded()
        }
    }
    
    @IBAction func btnOverviewTapped(_ sender: UIButton) {
        self.imageHalfHeightConstraint.priority = UILayoutPriority(950)
        
        UIView.animate(withDuration: 1.0) {
            self.lblOverviewTitle.textColor = .darkText
            self.lblDescription.textColor = .darkText
            self.overviewView.backgroundColor = .white
            
            self.contentView.layoutIfNeeded()
        }
    }
}
