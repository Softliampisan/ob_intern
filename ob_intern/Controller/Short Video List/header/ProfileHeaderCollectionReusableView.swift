//
//  ProfileHeaderCollectionReusableView.swift
//  ob_intern
//
//  Created by Soft Liampisan on 6/7/2566 BE.
//

import UIKit

protocol ProfileHeaderCollectionReusableViewDelegate: AnyObject {
    func didTapSettingsButton()
}

class ProfileHeaderCollectionReusableView: UICollectionReusableView {
    
    @IBOutlet weak var viewProfileHeader: UIView!
    @IBOutlet weak var imageViewFrontCover: UIImageView!
    @IBOutlet weak var imageViewProfilePic: UIImageView!
    @IBOutlet weak var labelProfileName: UILabel!
    @IBOutlet weak var buttonSettings: UIButton!
    
    weak var delegate: ProfileHeaderCollectionReusableViewDelegate?
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
    
    func hideSettings() {
        if ShortVideoManager.myProfile == false {
            buttonSettings.isHidden = true
        } else {
            buttonSettings.isHidden = false
        }
    }
    
    @IBAction func buttonSettingsAction(_ sender: Any) {
        delegate?.didTapSettingsButton()

    }
    
    
}
