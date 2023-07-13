//
//  DisplayLabelView.swift
//  TextOverlay
//
//  Created by Saharat Petcharayuttapan on 26/9/2565 BE.
//

import UIKit

class DisplayLabelView: UIView {

    var color: UIColor = .white
    var currentAlignment: TextEditDragDropViewController.TextAlignmentType = .center
    var onRemovePressedCompletion: ((DisplayLabelView) -> Void)?

    @IBOutlet weak var textLabel: PaddingLabel!
    @IBOutlet weak var closeButton: UIButton!

    class func commonInit() -> DisplayLabelView {
        let viewFromNib = Bundle.main.loadNibNamed("DisplayLabelView", owner: self)?.first as! DisplayLabelView
        viewFromNib.isUserInteractionEnabled = true
        viewFromNib.translatesAutoresizingMaskIntoConstraints = false

        return viewFromNib
    }

    override class func awakeFromNib() {
        super.awakeFromNib()
    }

    func settingLabel() {
        self.closeButton.setTitle("", for: .normal)
        self.closeButton.backgroundColor = .red
        self.closeButton.setImage(UIImage(systemName: "xmark.circle"), for: .normal)
        self.closeButton.tintColor = .white
        self.closeButton.layer.cornerRadius = self.closeButton.frame.height * 0.5
        self.closeButton.clipsToBounds = true
        self.textLabel.layer.borderColor = UIColor.red.cgColor
        self.textLabel.layer.borderWidth = 1.0
    }

    @IBAction func removeButtonPressed(_ sender: Any) {
        if let callback = self.onRemovePressedCompletion {
            print("REMOVED")
            callback(self)
        }
    }

    func hideUIForCapture(hidden: Bool) {
        if hidden {
            self.textLabel.layer.borderWidth = 0
            self.closeButton.isHidden = true
        } else {
            self.textLabel.layer.borderWidth = 1 // TODO
            self.closeButton.isHidden = false
        }
    }
}
