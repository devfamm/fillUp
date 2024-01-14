//
//  BlueBorderedButton.swift
//  fillUp
//
//  Created by devfamm on 11/1/23.
//

import UIKit

class BlueBorderedButton: UIButton {
    override class func awakeFromNib() {
        super.awakeFromNib()
        
    }
    override func layoutSubviews() {
        super.layoutSubviews()
        
        layer.cornerRadius = 5
        layer.borderWidth = 1
        layer.borderColor = UIColor.blue.cgColor
    }
    
    
    /*
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */
}
