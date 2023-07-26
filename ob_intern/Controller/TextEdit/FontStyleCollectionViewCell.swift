//
//  FontStyleCollectionViewCell.swift
//  TextOverlay
//
//  Created by Saharat Petcharayuttapan on 23/9/2565 BE.
//

import UIKit

class FontStyleCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var fontSampleLabel: UILabel!
    @IBOutlet weak var viewContainer: UIView!

    override var isSelected: Bool {
        didSet {
            self.viewContainer.layer.borderColor = isSelected ? UIColor.red.cgColor : UIColor.clear.cgColor
            self.viewContainer.layer.borderWidth = isSelected ? 2 : 0
        }
    }

    override func awakeFromNib() {
        super.awakeFromNib()

        self.viewContainer.layer.borderColor = UIColor.clear.cgColor
        self.viewContainer.clipsToBounds = true
    }

    func setFontName(fontName: String) {
        self.fontSampleLabel.font = UIFont(name: fontName, size: self.fontSampleLabel.font.pointSize)
    }
}
