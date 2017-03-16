//
//  ItemCollectionViewCell.swift
//  Let's LOL
//
//  Created by xiongmingjing on 15/03/2017.
//  Copyright © 2017 xiongmingjing. All rights reserved.
//

import UIKit

class ItemCollectionViewCell: UICollectionViewCell {
    
    var item: Item?
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
}
