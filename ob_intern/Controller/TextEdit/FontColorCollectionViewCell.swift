//
//  FontColorCollectionViewCell.swift
//  TextOverlay
//
//  Created by Saharat Petcharayuttapan on 23/9/2565 BE.
//

import UIKit

class FontColorCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var colorView: UIView!

    override var isSelected: Bool {
        didSet {
            self.colorView.layer.borderColor = isSelected ? UIColor.red.cgColor : UIColor.white.cgColor
            self.colorView.layer.borderWidth = isSelected ? 2 : 1
        }
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code

        //self.colorView.roundCorners()
        self.colorView.layer.borderWidth = 1
        self.colorView.layer.borderColor = UIColor.white.cgColor
        self.colorView.clipsToBounds = true
    }

    func setColor(color: UIColor) {
        self.colorView.backgroundColor = color
    }
}
