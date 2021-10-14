//
//  ProductsViewCell.swift
//  TwelveHundred
//
//  Created by Mas'ud on 8/15/21.
//

import Foundation
import UIKit

class ProductsViewCell:UICollectionViewCell {
    
   
    @IBOutlet weak var productPrice: UILabel!
    @IBOutlet weak var productCategory: UILabel!
    @IBOutlet weak var productName: UILabel!
    @IBOutlet weak var ProductView: UIView!
    @IBOutlet weak var productImage: UIImageView!
    
    func cornerRadius(){
        ProductView.layer.cornerRadius = ProductView.frame.height/20
        /*let r = productImage.bounds.size.height/10
        let path = UIBezierPath(roundedRect: productImage.bounds, byRoundingCorners: [.bottomLeft, .bottomRight], cornerRadii: CGSize(width: r, height: r))
        let mask = CAShapeLayer()
        mask.path = path.cgPath*/
        productImage.layer.cornerRadius = ProductView.frame.height/20
    }
}
