//
//  Thumbnailextension.swift
//  PhotoBooth
//
//  Created by Ravi on 29/08/18.
//  Copyright © 2018 Ravi. All rights reserved.
//

import UIKit
//private let a = 10
extension UIImage {
    func thumbnailOfSize(_ newSize: CGSize) -> UIImage? {
        let renderer = UIGraphicsImageRenderer(size: newSize)
        let thumbnail = renderer.image {_ in
            self.draw(in: CGRect.init(origin: CGPoint.zero, size: newSize))
        }
        return thumbnail
       // print(a)
    }
}
