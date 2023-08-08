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
    @IBOutlet weak var labelViewCount: UILabel!
    @IBOutlet weak var imageViewIcon: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        imageViewVideo.layer.cornerRadius = 16
        imageViewVideo.clipsToBounds = true

    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        imageViewVideo.image = nil
    }
    
    func setData(imageURL: String,
                 label: String){
        self.labelViewCount.text = label
        self.imageViewVideo.sd_setImage(with: URL(string: imageURL))
    }
}
