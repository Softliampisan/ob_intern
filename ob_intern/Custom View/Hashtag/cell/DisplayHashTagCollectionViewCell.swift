//
//  DisplayHashTagCollectionViewCell.swift
//  Joy
//
//  Created by TanGMo SuChaYA on 24/5/22.
//  Copyright © 2022 ookbee. All rights reserved.
//

import UIKit

class DisplayHashTagCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var hashtagView: UIView!
    @IBOutlet weak var lblTitle: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }
    
    func setData(hashtag: String) {
        lblTitle.text = "#" + hashtag
        lblTitle.textColor = .systemPink
        hashtagView.layer.borderWidth = 1
        hashtagView.layer.cornerRadius = hashtagView.frame.height/2
        hashtagView.layer.borderColor = UIColor.systemPink.cgColor
        
    }

//    func setData(hashtag: String, isHighlight: Bool) {
//        lblTitle.text = "#" + hashtag
//        lblTitle.textColor = isHighlight ? .red : .lightGray
//        hashtagView.layer.borderWidth = 1
//        hashtagView.layer.cornerRadius = hashtagView.frame.height/2
//        hashtagView.layer.borderColor = isHighlight ? UIColor.red.cgColor : UIColor.lightGray.cgColor
//    }

}
