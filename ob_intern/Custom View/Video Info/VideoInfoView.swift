//
//  VideoInfoView.swift
//  ob_intern
//
//  Created by Soft Liampisan on 20/6/2566 BE.
//

import SDWebImage
import Foundation
import UIKit

protocol VideoInfoViewDelegate: AnyObject {
    func updateHeight(height: CGFloat)
    func tapProfile()
}

class VideoInfoView: InitializeXibView {
    
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var stackView: UIStackView!
    @IBOutlet weak var imageViewProfilePic: UIImageView!
    @IBOutlet weak var labelProfileName: UILabel!
    @IBOutlet weak var labelPostTime: UILabel!
    @IBOutlet weak var viewHashtag: SocialPostHashTagView!
    @IBOutlet weak var labelInfo: UILabel!
    @IBOutlet weak var moreButton: UIButton!
    @IBOutlet weak var buttonToProfile: UIButton!
    @IBOutlet weak var scrollView: UIScrollView!
    
    private let numLinesCollapsed = 2
    private var originalString: String!
    private var isExpanded = false
    private var labelPaddingTop: CGFloat = 8
    weak var delegate: VideoInfoViewDelegate?
    var post: ShortVideoPost?

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupView()
    }
    
    private func setupView() {
        setupContainerView()
        setupStackView()
        setUpButtons()
        setLabelInfo()
        DispatchQueue.main.async {
            self.collapse()
        }

    }


    private func setupContainerView() {
        containerView.layer.masksToBounds = true
        self.addSubview(containerView)
        scrollView.contentOffset = .zero
        containerView.addSubview(scrollView)
        scrollView.addSubview(labelInfo)
        containerView.addSubview(viewHashtag)
        NSLayoutConstraint.activate([
            containerView.topAnchor.constraint(equalTo: topAnchor),
            containerView.leadingAnchor.constraint(equalTo: leadingAnchor),
            containerView.trailingAnchor.constraint(equalTo: trailingAnchor),
            containerView.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
        
    }
    
    private func setupStackView() {
        setupImageAndLabel()
        containerView.addSubview(stackView)
        stackView.addSubview(imageViewProfilePic)
        stackView.addSubview(labelProfileName)
        stackView.addSubview(labelPostTime)
    }
    
    private func setUpButtons() {
        containerView.addSubview(buttonToProfile)
        containerView.addSubview(moreButton)
    }
    
    private func setupImageAndLabel() {
        imageViewProfilePic.layer.cornerRadius = imageViewProfilePic.frame.size.width / 2
        imageViewProfilePic.clipsToBounds = true
    }
    private func getHeightForString(str: String) -> CGFloat {
        let labelWidth = labelInfo.frame.size.width
        let labelFont = labelInfo.font
        
        let constraintRect = CGSize(width: labelWidth, height: .greatestFiniteMagnitude)
        let boundingBox = str.boundingRect(with: constraintRect,
                                           options: [.usesLineFragmentOrigin, .usesFontLeading],
                                           attributes: [NSAttributedString.Key.font: labelFont as Any],
                                           context: nil)
        return ceil(boundingBox.height)
    }
    
    func config(delegate: VideoInfoViewDelegate,
                profileImageURL: String,
                profileName: String,
                postTime: String,
                caption: String?,
                hashtag: [String]) {
        self.delegate = delegate
        self.imageViewProfilePic.sd_setImage(with: URL(string: profileImageURL))
        self.labelProfileName.text = profileName
        self.labelPostTime.text = postTime
        self.labelInfo.text = caption
        self.setLabelInfo()
        self.viewHashtag.setData(hashtags: hashtag)
        self.updateContentSize()
    }
    
    func setLabelInfo() {
        let imageAttachment = NSTextAttachment()
        imageAttachment.image = UIImage(systemName: "globe.europe.africa.fill")?.withTintColor(.white)
        imageAttachment.bounds = CGRect(x: 0, y: -3, width: 14, height: 14)

        let attributedString = NSMutableAttributedString(string: "")
        let imageString = NSAttributedString(attachment: imageAttachment)
        attributedString.append(imageString)

        guard let labelText = labelInfo.text else { return }
        let textString = NSAttributedString(string: " " + labelText)
        attributedString.append(textString)

        labelInfo.attributedText = attributedString
    }
    
    func toggleLabelLines() {
        if isExpanded {
            collapse()
        } else {
            expand()
        }
        isExpanded.toggle()
    }
    
    private func collapse() {
        labelInfo.numberOfLines = numLinesCollapsed
        updateContentSize()
    }
    
    private func expand() {
        labelInfo.numberOfLines = 0
        updateContentSize()
    }
    
    private func updateContentSize() {
        labelInfo.sizeToFit()
        let stackAndPaddingHeight = stackView.frame.height + labelPaddingTop
        let containerHeight = stackAndPaddingHeight + labelInfo.frame.height + viewHashtag.frame.height + moreButton.frame.height
        containerView.frame = CGRect(x: containerView.frame.origin.x, y: containerView.frame.origin.y, width: containerView.frame.height, height: containerHeight)
        containerView.layoutIfNeeded()
        scrollView.contentSize = CGSize(width: self.view.frame.width, height: labelInfo.frame.height)
        delegate?.updateHeight(height: containerView.frame.height)

    }


    @IBAction func moreButtonAction(_ sender: Any) {
        toggleLabelLines()
        let newButtonTitle = self.isExpanded ? "ย่อ" : "เพิ่มเติม"
        moreButton.titleLabel?.font = .systemFont(ofSize: 14.0, weight: .bold)
        moreButton.setTitle(newButtonTitle, for: .normal)
    }
    
    
    @IBAction func tapProfile(_ sender: Any) {
        delegate?.tapProfile()
    }
    
    
}
