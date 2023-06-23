//
//  CustomTextView.swift
//  ob_intern
//
//  Created by Soft Liampisan on 21/6/2566 BE.
//

import Foundation
import UIKit

class CustomTextView: UITextView {

    private var originalText: String = ""
    private var storedText: String = ""
    private let truncationLength: Int = 2

    override init(frame: CGRect, textContainer: NSTextContainer?) {
        super.init(frame: frame, textContainer: textContainer)
        commonInit()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }

    private func commonInit() {
        isSelectable = true
        isEditable = false
        delegate = self
    }

    func setAttributedTextWithTruncation(_ text: String) {
        originalText = text
        let truncatedText = truncateText(to: truncationLength)
        storedText = truncatedText + " " + NSLocalizedString("More", comment: "")
        
        let attributedText = NSMutableAttributedString(string: storedText)
        attributedText.addAttribute(.link, value: "more", range: NSRange(location: truncatedText.count + 1, length: storedText.count - truncatedText.count - 1))
        
        self.attributedText = attributedText
    }

    private func truncateText(to length: Int) -> String {
        guard originalText.count > length else {
            return originalText
        }
        let endIndex = originalText.index(originalText.startIndex, offsetBy: length)
        return String(originalText[..<endIndex])
    }

}

extension CustomTextView: UITextViewDelegate {

    func textView(_ textView: UITextView, shouldInteractWith URL: URL, in characterRange: NSRange, interaction: UITextItemInteraction) -> Bool {
        if URL.absoluteString == "more" {
            textView.attributedText = NSAttributedString(string: originalText, attributes: [.font: textView.font!])

            return false
        }
        return true
    }
}
