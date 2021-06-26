//
//  PhotosCollectionViewCell.swift
//  Pocket Money
//
//  Created by Chloe Cheng on 12/2/19.
//  Copyright © 2019 Chloe Cheng. All rights reserved.
//

import UIKit

class PhotosCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var photoImageView: UIImageView!
    
    var photo: Photo! {
        didSet {
            photoImageView.image = photo.image
        }
    }
}
