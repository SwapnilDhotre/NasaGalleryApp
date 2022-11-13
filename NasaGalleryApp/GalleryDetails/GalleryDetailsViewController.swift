//
//  GalleryDetailsViewController.swift
//  NasaGalleryApp
//
//  Created by Swapnil_Dhotre on 11/12/22.
//

import UIKit
import SDWebImage

class GalleryDetailsViewController: UIViewController {
    var selectedIndex: IndexPath!
    var galleryData: [GalleryItemViewModel] = []

    @IBOutlet weak var backButton: UIButton!
    @IBOutlet weak var collectionView: UICollectionView!
    
    static func create(selectedIndex: IndexPath, galleryData: [GalleryItemViewModel]) -> GalleryDetailsViewController {
        let controller = GalleryDetailsViewController()
        controller.selectedIndex = selectedIndex
        controller.galleryData = galleryData
        
        return controller
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.styleUI()
        self.setupCollectionView()
        
        self.scrollToSelectedItem()
        
        // Prefetch items next to seleted item
        self.prefetchPreviousAndNextItem()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.navigationController?.navigationBar.isHidden = true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        self.navigationController?.navigationBar.isHidden = false
    }
    
    func prefetchPreviousAndNextItem() {
        var urlStrings: [String?] = []
        if self.selectedIndex.row == 0 && self.galleryData.count > 2 {
            // Prefetch next 2 items
            urlStrings = [self.galleryData[1].getHDURL(), self.galleryData[2].getHDURL()]
        } else if self.selectedIndex.row == self.galleryData.count - 1 && self.galleryData.count > 2 {
            // Prefetch previous 2 items
            urlStrings = [self.galleryData[self.galleryData.count - 2].getHDURL(), self.galleryData[self.galleryData.count - 3].getHDURL()]
        } else {
            // Prefetch previous and next item
            urlStrings = [self.galleryData[self.selectedIndex.row - 1].getHDURL(), self.galleryData[self.selectedIndex.row + 1].getHDURL()]
        }
        
        var urls: [URL] = []
        for url in urlStrings {
            if let urlString = url, let url = URL(string: urlString) {
                urls.append(url)
            }
        }
        
        // Prefetch and keep in cache
        SDWebImagePrefetcher.shared.prefetchURLs(urls)
    }
    
    // Scroll to selected item
    func scrollToSelectedItem() {
        DispatchQueue.main.asyncAfter(deadline: .now()) { [weak self] in
            self?.collectionView.scrollToItem(at: self!.selectedIndex!, at: .centeredHorizontally, animated: false)
            
            self?.collectionView.isPagingEnabled = true
         }
    }
    
    func styleUI() {
        self.backButton.setImage(UIImage(named: "back_arrow"), for: .normal)
        self.backButton.imageView?.contentMode = .scaleAspectFit
        self.backButton.setTitle(" ", for: .normal)
        self.backButton.backgroundColor = .white
        self.backButton.layer.cornerRadius = 20
        self.backButton.layer.masksToBounds = true
    }
    
    func setupCollectionView() {
        self.collectionView.accessibilityIdentifier = "gallery_details_collectionView"
        
        self.collectionView.dataSource = self
        self.collectionView.delegate = self
        self.collectionView.prefetchDataSource = self
        
        self.collectionView.register(UINib(nibName: "SwipeCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "swipe_cell")
    }
       
    
    @IBAction func backButtonTapped() {
        self.navigationController?.popViewController(animated: true)
    }
}

extension GalleryDetailsViewController: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.galleryData.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let swipeCell = collectionView.dequeueReusableCell(withReuseIdentifier: "swipe_cell", for: indexPath) as? SwipeCollectionViewCell else {
            return UICollectionViewCell()
        }
        
        let galleryViewModel = self.galleryData[indexPath.row]
        swipeCell.setData(viewModel: galleryViewModel)
        return swipeCell
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        if let swipeCell = cell as? SwipeCollectionViewCell {
            swipeCell.overviewView.layer.cornerRadius = 20
            swipeCell.overviewView.layer.masksToBounds = true
        }
    }
    
    // Flow layout delegate methods
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.width, height: collectionView.frame.height)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
}

extension GalleryDetailsViewController: UICollectionViewDataSourcePrefetching {
    func collectionView(_ collectionView: UICollectionView, prefetchItemsAt indexPaths: [IndexPath]) {
        var urls: [URL] = []
        for indexPath in indexPaths {
            let model = self.galleryData[indexPath.row]
            if let urlString = model.getHDURL(), let url = URL(string: urlString) {
                urls.append(url)
            }
        }
        
        // Prefetch and keep in cache
        SDWebImagePrefetcher.shared.prefetchURLs(urls)
    }
}
