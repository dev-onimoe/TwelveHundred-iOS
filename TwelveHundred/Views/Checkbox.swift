//
//  File.swift
//  TwelveHundred
//
//  Created by Mas'ud on 6/30/21.
//

import UIKit

class CheckBox:UIButton {
    
    override func awakeFromNib() {
    
    
        self.setImage(UIImage(named:"selected"), for: .selected)
        self.setImage(UIImage(named:"rectangle"), for: .normal)
        self.addTarget(self, action: #selector(CheckBox.buttonClicked(_:)), for: .touchUpInside)
    }
    
    @objc func buttonClicked(_ sender: UIButton) {
        self.isSelected = !self.isSelected
     }


}
