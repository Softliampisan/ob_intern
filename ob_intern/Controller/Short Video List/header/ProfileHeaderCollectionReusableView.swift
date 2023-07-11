//
//  ProfileHeaderCollectionReusableView.swift
//  ob_intern
//
//  Created by Soft Liampisan on 6/7/2566 BE.
//

import UIKit

class ProfileHeaderCollectionReusableView: UICollectionReusableView {
    
    @IBOutlet weak var viewProfileHeader: UIView!
    @IBOutlet weak var imageViewFrontCover: UIImageView!
    @IBOutlet weak var imageViewProfilePic: UIImageView!
    @IBOutlet weak var labelProfileName: UILabel!
    
    static let identifier = "ProfileHeaderCollectionReusableView"

    override func awakeFromNib() {
        super.awakeFromNib()
        imageViewProfilePic.layer.cornerRadius = 42.5
        imageViewProfilePic.clipsToBounds = true
      
    }
 
    func setData(imageURLProfilePic: String,
                 imageURLFrontCover: String,
                 label: String){
        self.labelProfileName.text = label
        self.imageViewProfilePic.sd_setImage(with: URL(string: imageURLProfilePic))
        self.imageViewFrontCover.sd_setImage(with: URL(string: imageURLFrontCover))

    }
    
    
}
