//
//  VideoInfoView.swift
//  ob_intern
//
//  Created by Soft Liampisan on 20/6/2566 BE.
//

import Foundation
import UIKit

class VideoInfoView: InitializeXibView {
    
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var stackView: UIStackView!
    @IBOutlet weak var imageViewProfilePic: UIImageView!
    @IBOutlet weak var labelProfileName: UIView!
    @IBOutlet weak var labelPostTime: UILabel!
    @IBOutlet weak var textViewInfo: CustomTextView!
    @IBOutlet weak var viewHashtag: UIView!
    
    private var storedText: String = ""

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
//        textViewInfo.delegate = self
//        textViewInfo.isSelectable = true
//        textViewInfo.isEditable = false
//        textViewInfo.layoutIfNeeded()
//        textViewInfo.translatesAutoresizingMaskIntoConstraints = true
//        textViewInfo.sizeToFit()
//        setPublicPrivateAttribute()
        //textViewInfo = CustomTextView(frame: CGRect(x: 0, y: 0, width: 200, height: 100))
        let text = "Lorem ipsum dolor sit er elit lamet, consectetaur cillium adipisicing pecu, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proid"
        textViewInfo.setAttributedTextWithTruncation(text)
    }


    func setPublicPrivateAttribute() {
        let mainThemeColorAttributes: [NSAttributedString.Key: Any] = [.foregroundColor: UIColor.white]
        let attributedMessage = NSMutableAttributedString()
        let publicImageAttachment = NSTextAttachment()
        let publicImage = UIImage(systemName: "globe.europe.africa.fill")?.withTintColor(.white)

        publicImageAttachment.bounds = CGRect(x: 0, y: -4, width: 14, height: 14)
        publicImageAttachment.image = publicImage

        let publicImageAttributedMessage = NSAttributedString(attachment: publicImageAttachment)

        let moreText = " more"
        
        if let fullText = textViewInfo.text {
            let truncationResult = fullText.truncate(to: 94) // Truncate by characters
            let trailing: String = "..."
            let truncatedText = truncationResult.truncated
            let remainingText = truncationResult.remaining

            let text = NSMutableAttributedString(string: truncatedText + trailing, attributes: mainThemeColorAttributes)
            let moreRange = NSRange(location: truncatedText.count, length: moreText.count)
            let moreLink = NSAttributedString(string: moreText, attributes: [.link: URL(string: "more://")!])
            text.append(moreLink)

            attributedMessage.append(publicImageAttributedMessage)
            attributedMessage.append(text)

            textViewInfo.attributedText = attributedMessage
            print(textViewInfo.attributedText.string)
            
            let storedTextWithoutEllipsis = truncatedText + remainingText
            self.storedText = storedTextWithoutEllipsis
           
        }
    }
    
    private func setupContainerView() {
        containerView.layer.masksToBounds = true
        self.addSubview(containerView)
        containerView.addSubview(textViewInfo)
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
    
    private func setupImageAndLabel() {
        imageViewProfilePic.layer.cornerRadius = imageViewProfilePic.frame.size.width / 2
        imageViewProfilePic.clipsToBounds = true
    }
}

extension VideoInfoView: UITextViewDelegate {
    
//    func textView(_ textView: UITextView, shouldInteractWith URL: URL, in characterRange: NSRange, interaction: UITextItemInteraction) -> Bool {
//        if URL.scheme == "more" {
//            print("more is pressed")
//            textViewInfo.text = storedText
//
//            return false
//        }
//        else {
//            return true
//        }
//    }
}
extension String {
    
//    func attributed(using font: UIFont) -> NSAttributedString {
//        return NSAttributedString(string: self, attributes: [.font: font])
//    }
    func truncate(to length: Int, trailing: String = "...") -> (truncated: String, remaining: String) {
               guard self.count > length else {
                   return (self, "")
               }
               let index = self.index(self.startIndex, offsetBy: length)
               let truncated = String(self[..<index])
               let remaining = String(self[index...])
               return (truncated, remaining)
        }
      
}
