//
//  DatacollectionViewCell.swift
//  TwelveHundred
//
//  Created by Mas'ud on 7/19/21.
//

import Foundation
import UIKit

class DatacollectionViewcell:UICollectionViewCell {
    
    @IBOutlet weak var cellImage: UIImageView!
    
    func loadImage() {
        cellImage.image = UIImage.init(named: "bbckgrd1")
    }
}
