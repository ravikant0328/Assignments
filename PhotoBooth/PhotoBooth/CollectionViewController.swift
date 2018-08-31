//
//  CollectionViewController.swift
//  PhotoBooth
//
//  Created by Ravi on 29/08/18.
//  Copyright © 2018 Ravi. All rights reserved.
//

import UIKit


class CollectionViewController: UICollectionViewController {
    
    @IBOutlet var photolistcollectionView: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView?.register(UINib.init(nibName: String(describing: PhotoCollectionViewCell.self), bundle: Bundle.main), forCellWithReuseIdentifier: "PhotoCell")
        title = "Collection View"
    }

    private let reuseIdentifier = "PhotoCell"
    private let thumbnailSize = CGSize(width: 70.0, height: 70.0)
    private let sectionInsets = UIEdgeInsets(top: 10, left: 5.0, bottom: 10.0, right: 5.0)
    private let photos = ["photo1","photo2","photo3","photo4","photo5"]
  }


extension CollectionViewController {
    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return photos.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! PhotoCollectionViewCell
       // cell.qadjkag.text = "qwertyt"
        let fullSizedImage = UIImage(named:photos[indexPath.row] )
        cell.imageView.image = fullSizedImage?.thumbnailOfSize(thumbnailSize)
        return cell
    }
}


extension CollectionViewController : UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return thumbnailSize
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return sectionInsets
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let vc = ZoomedPhotoViewController()//nibName: "ZoomedPhotoViewController", bundle: nil)
        vc.photoName = photos[indexPath.row]
        navigationController?.pushViewController(vc, animated: true)

    }

}
