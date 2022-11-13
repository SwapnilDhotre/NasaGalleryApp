//
//  GalleryHomeViewController.swift
//  NasaGalleryApp
//
//  Created by Swapnil_Dhotre on 11/12/22.
//

import UIKit

class GalleryHomeViewController: UIViewController {
    private var viewModel: GalleryHomeViewModel?
    
    @IBOutlet weak var lblErrorInfo: UILabel!
    @IBOutlet weak var errorPage: UIStackView!
    @IBOutlet weak var collectionView: UICollectionView!
    
    static func create(viewModel: GalleryHomeViewModel) -> GalleryHomeViewController {
        let controller = GalleryHomeViewController()
        controller.viewModel = viewModel
        
        return controller
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "Gallery Home"
        self.setupCollectionView()
        self.setListener()
    }
    
    func setupCollectionView() {
        self.collectionView.dataSource = self
        self.collectionView.delegate = self
        
        self.collectionView.register(UINib(nibName: "GalleryCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "gallery_cell")
    }
    
    // Set listener to observe data change from api request
    func setListener() {
        self.errorPage.isHidden = true
        
        // Bind view controller to loading
        viewModel?.galleryDataLoading.bind { [weak self] isLoading in
            DispatchQueue.main.async {
                if isLoading != nil {
                    print("Show loading")
                    isLoading! ? self?.showLoader(title: "Please wait...") : self?.hideLoader()
                }
            }
        }
        
        // Bind view controller to error updates
        viewModel?.galleryDataFetchError.bind { [weak self] error in
            DispatchQueue.main.async {
                if error != nil {
                    if let networkError = error as? NetworkError {
                        self?.errorPage.isHidden = false
                        self?.lblErrorInfo.text = networkError.description
                    } else if let decodeError = error as? DecodingError {
                        self?.errorPage.isHidden = false
                        self?.lblErrorInfo.text = "Data not received properly."
                    } else {
                        self?.errorPage.isHidden = false
                        self?.lblErrorInfo.text = "Could not proceed. Please try again later."
                    }
                    
                    print("Show error:: \(String(describing: error?.localizedDescription))")
                }
            }
        }
        
        // Bind view controller to data updates
        viewModel?.galleryData.bind { [weak self] _ in
            DispatchQueue.main.async {
                print("Data received")
                self?.errorPage.isHidden = true
                self?.collectionView.reloadData()
            }
        }
        
        viewModel?.getGalleryData()
    }
}

extension GalleryHomeViewController: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.viewModel?.galleryData.value.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let galleryCell = collectionView.dequeueReusableCell(withReuseIdentifier: "gallery_cell", for: indexPath) as? GalleryCollectionViewCell else {
            return UICollectionViewCell()
        }
        
        let galleryViewModel = self.viewModel!.galleryData.value[indexPath.row]
        galleryCell.setData(viewModel: galleryViewModel)
        return galleryCell
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        if let galleryCell = cell as? GalleryCollectionViewCell {
            galleryCell.containerView.layer.cornerRadius = 5
            galleryCell.containerView.layer.masksToBounds = true
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let controller = GalleryDetailsViewController.create(selectedIndex: indexPath, galleryData: self.viewModel!.galleryData.value)
        self.navigationController?.pushViewController(controller, animated: true)
    }
    
    
    // Flow layout delegate methods
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let spacingFromLeftRight: CGFloat = 10
        let interSpacing: CGFloat = 5
        let size = (collectionView.frame.size.width - interSpacing - spacingFromLeftRight) / 2
        return CGSize(width: size, height: size)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 5
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 5
    }
}
