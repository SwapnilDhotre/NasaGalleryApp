//
//  GalleryCollectionViewCell.swift
//  NasaGalleryApp
//
//  Created by Swapnil_Dhotre on 11/12/22.
//

import UIKit
import SDWebImage

class GalleryCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var title: UILabel!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var containerView: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    // Updates UI from View Model
    func setData(viewModel: GalleryItemViewModel) {
        self.title.text = viewModel.getImageTitle()
        self.imageView.sd_imageIndicator = SDWebImageActivityIndicator.white
        
        self.imageView.sd_setImage(with: URL(string: viewModel.getThumbnailURL() ?? "")) { image, error, _, _ in
            if error != nil {
                self.imageView.image = UIImage(named: "no_image_found")
            }
        }
    }
}
