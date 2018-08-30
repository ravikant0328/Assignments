//
//  ZoomedPhotoViewController.swift
//  PhotoBooth
//
//  Created by Ravi on 29/08/18.
//  Copyright © 2018 Ravi. All rights reserved.
//

import UIKit

class ZoomedPhotoViewController: UIViewController {

    @IBOutlet weak var imageViewZoomed: UIImageView!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var imageViewBottomConstraint: NSLayoutConstraint!
    @IBOutlet weak var imageViewLeadingConstraint: NSLayoutConstraint!
    @IBOutlet weak var imageViewTopConstraint: NSLayoutConstraint!
    @IBOutlet weak var imageViewTrailingConstraint: NSLayoutConstraint!
    var photoName: String?
   
    override func viewDidLoad() {
//        func viewWillLayoutSubviews() {
//            super.viewWillLayoutSubviews()
//            updateMinZoomScaleForSize(view.bounds.size)
//        }
//        func updateMinZoomScaleForSize(_ size: CGSize) {
//            let widthScale = size.width / imageViewZoomed.bounds.width
//            let heightScale = size.height / imageViewZoomed.bounds.height
//            let minScale = min(widthScale, heightScale)
//
//            scrollView.minimumZoomScale = minScale
//            scrollView.zoomScale = minScale
//        }
        if let photoName = photoName {
            imageViewZoomed.image = UIImage(named: photoName)
        }
        
    }
}

//extension ZoomedPhotoViewController: UIScrollViewDelegate {
//    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
//        return imageViewZoomed
//    }
//}
