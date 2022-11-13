//
//  UIViewController_Extension.swift
//  NasaGalleryApp
//
//  Created by Swapnil_Dhotre on 11/12/22.
//

import UIKit

extension UIViewController {
    
    // Show loader
    func showLoader(title: String) {
        CVProgressHUD.showProgressHUD(title: title)
    }
    
    // Hide loader
    func hideLoader() {
        CVProgressHUD.hideProgressHUD()
    }
    
    // Clears navigation bar
    func clearNavigationBar() {
        navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        navigationController?.navigationBar.shadowImage = UIImage()
        navigationController?.navigationBar.isTranslucent = true
    }
    
    // Clear navigation bar and add custom back button if required.
    func clearNavigationBar(withBackButton isBackVisible: Bool, selector: Selector) {
        self.clearNavigationBar()
        if (isBackVisible) {
            let button = UIButton(frame: CGRect(x: 0, y: 0, width: 40, height: 40))
            
            button.addTarget(self, action: selector, for: .touchUpInside)
            
            let backBarButton = UIBarButtonItem(customView: button)
            self.navigationItem.leftBarButtonItem = backBarButton
        }
    }
}
