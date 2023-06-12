//
//  EditShortVideoCoverCollectionViewCell.swift
//  ob_intern
//
//  Created by Soft Liampisan on 12/6/2566 BE.
//

import UIKit

class EditShortVideoCoverCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var imageViewVideoCover: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    func setData(imageURL: String){
        self.imageViewVideoCover.sd_setImage(with: URL(string: imageURL))
    }
}
