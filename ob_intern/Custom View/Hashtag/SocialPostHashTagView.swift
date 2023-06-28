//
//  SocialPostHashTagView.swift
//  Joy
//
//  Created by TanGMo SuChaYA on 24/5/22.
//  Copyright © 2022 ookbee. All rights reserved.
//

import UIKit

protocol SocialPostHashTagViewDelegate: AnyObject {
    func setHeightConstraint(viewHeight : CGFloat)
    func setViewHidden(isHidden: Bool)
}

class SocialPostHashTagView: InitializeXibView {

    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var collectionHeightConstraint: NSLayoutConstraint!
    
    weak var delegate: SocialPostHashTagViewDelegate?
    
    var hashtags : [String] = []
    var viewIsHidden: Bool = true
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.setupView()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    func setupView() {
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.register(cell: DisplayHashTagCollectionViewCell.self)

        
        let layout = LeftAlignedFlowLayout()
        layout.sectionInset = UIEdgeInsets(top: 10, left: 10, bottom: 0, right: 10)
        self.collectionView.setCollectionViewLayout(layout, animated: true)
        
    }
    
    func setData(hashtags: [String]) {
        self.hashtags = hashtags
        
        collectionView.reloadData()
        self.collectionView.setNeedsLayout()
        self.collectionView.layoutIfNeeded()
        let height = self.collectionView.contentSize.height
        self.collectionHeightConstraint.constant = height
        delegate?.setHeightConstraint(viewHeight: height)
        
        if self.hashtags.count <= 0 {
            delegate?.setViewHidden(isHidden: true)
        } else {
            delegate?.setViewHidden(isHidden: false)
        }
    }
    

}

extension SocialPostHashTagView: UICollectionViewDataSource,
                                            UICollectionViewDelegate,
                                            UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return hashtags.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "DisplayHashTagCollectionViewCell", for: indexPath) as? DisplayHashTagCollectionViewCell else { return UICollectionViewCell() }
        
        cell.setData(hashtag: hashtags[indexPath.row])
            
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let label = UILabel(frame: CGRect.zero)
        if hashtags.count > 0, let hashtags = hashtags.takeSafe(index: indexPath.row) {
            label.font = UIFont.systemFont(ofSize: 14)
            label.text = hashtags
        }
        label.sizeToFit()
        
        return CGSize(width: label.frame.width + 20, height: 26)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 10
    }
    
}

