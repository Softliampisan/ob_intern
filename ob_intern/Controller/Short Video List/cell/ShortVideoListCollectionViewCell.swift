//
//  CollectionViewCell.swift
//  ob_intern
//
//  Created by Soft Liampisan on 7/6/2566 BE.
//

import UIKit
import SDWebImage

class ShortVideoListCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var imageViewVideo: UIImageView!
    @IBOutlet weak var labelViews: UILabel!
    @IBOutlet weak var iconViews: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        imageViewVideo.layer.cornerRadius = 16
        //imageViewVideo.layer.masksToBounds = true

    }
    
    func setData(imageURL: String,
                 label: String){
        self.labelViews.text = label
        self.imageViewVideo.sd_setImage(with: URL(string: imageURL))
    }
}
