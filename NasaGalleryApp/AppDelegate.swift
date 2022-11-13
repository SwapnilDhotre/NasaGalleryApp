//
//  AppDelegate.swift
//  NasaGalleryApp
//
//  Created by Swapnil_Dhotre on 11/12/22.
//

import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        self.window = UIWindow(frame: UIScreen.main.bounds)
        
        
        let viewModel = GalleryHomeViewModel(networkService: NetworkManager())
        window?.rootViewController = UINavigationController(rootViewController: GalleryHomeViewController.create(viewModel: viewModel))
        window?.makeKeyAndVisible()
        
        return true
    }
}

