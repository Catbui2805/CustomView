//
//  SlideImageView.swift
//  CustomerView
//
//  Created by Nguyen Tran Cong on 10/18/19.
//  Copyright © 2019 Nguyen Tran. All rights reserved.
//

import UIKit

class SlideImageView: UIView {

    var imageList: [UIImage] = []
    var counter: Int = 0
    var shouldPlaySlide: Bool = false
    var shouldShowCurrentPage: Bool = false
    var timer: Timer = Timer()
    
    @IBOutlet var contentView: UIView!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var currentPageLabel: UILabel!
    @IBOutlet weak var pageControl: UIPageControl!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        commitInit()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commitInit()
    }
    
    func commitInit() {
        let bundle = Bundle(for: type(of: self))
        bundle.loadNibNamed("SlideImageView", owner: self, options: nil)
        addSubview(contentView)
        contentView.frame = bounds
        contentView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        
        currentPageLabel.text = "\(counter + 1)/\(imageList.count)"
        
        pageControl.currentPage = counter
        pageControl.numberOfPages = imageList.count
        pageControl.addTarget(self, action: #selector(pageControlChangeImage(_:)), for: .touchUpInside)
        
        initCollectionView()
        
        if shouldPlaySlide {
            DispatchQueue.main.async {
                self.timer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(self.autoChangeImage), userInfo: nil, repeats: true)
            }
        }
        
        if shouldShowCurrentPage {
            currentPageLabel.isHidden = false
        } else {
            currentPageLabel.isHidden = true
        }
    }
    
    private func initCollectionView() {
        let nib = UINib(nibName: "ImageCollectionViewCell", bundle: nil)
        collectionView.register(nib, forCellWithReuseIdentifier: "ImageCollectionViewCell")
        collectionView.dataSource = self
    }
    
}

@objc extension SlideImageView {
    func pageControlChangeImage(_ sender: UIPageControl) {
        guard let currentPage = sender.currentPage as? Int else { return }
        counter = currentPage
        let index = IndexPath(row: counter, section: 0)
        collectionView.scrollToItem(at: index, at: .centeredHorizontally, animated: true)
    }
    
    func autoChangeImage() {
        if counter < imageList.count {
            let index = IndexPath(item: counter, section: 0)
            collectionView.scrollToItem(at: index, at: .centeredHorizontally, animated: true)
        } else {
            counter = 0
            let index = IndexPath(item: counter, section: 0)
            collectionView.scrollToItem(at: index, at: .centeredHorizontally, animated: false)
        }
        pageControl.currentPage = counter
        currentPageLabel.text = "\(counter + 1)/\(imageList.count)"
        counter += 1
    }
    
}

// MARK: - UICollectionViewDelegateFlowLayout
extension SlideImageView: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let size = collectionView.frame.size
        return CGSize(width: size.width, height: size.height)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
}

// MARK: - UICollectionViewDataSource
extension SlideImageView: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return imageList.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ImageCollectionViewCell", for: indexPath) as? ImageCollectionViewCell else {
            fatalError("can't dequeue ImageCell")
        }
        cell.imageView.image = imageList[indexPath.row]
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        counter = indexPath.row
        pageControl.currentPage = counter
        currentPageLabel.text = "\(counter + 1)/\(imageList.count)"
    }
    
}
