//
//  ZoomedPhotoViewController.swift
//  PhotoBooth
//
//  Created by Ravi on 29/08/18.
//  Copyright © 2018 Ravi. All rights reserved.
//

import UIKit

class ZoomedPhotoViewController: UIViewController,UIScrollViewDelegate{

    @IBOutlet weak var imageViewZoomed: UIImageView!
    @IBOutlet weak var scrollView: UIScrollView!
    var photoName: String?
   
    override func viewDidLoad() {

        if let photoName = photoName {
            imageViewZoomed.image = UIImage(named: photoName)
        }
        scrollView.minimumZoomScale = 1.0
        scrollView.maximumZoomScale = 6.0
        title = "Zoomed View"
        
    }
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return imageViewZoomed
    }

}


