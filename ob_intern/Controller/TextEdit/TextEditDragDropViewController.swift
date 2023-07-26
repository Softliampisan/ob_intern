//
//  TextEditDragDropViewController.swift
//  TextOverlay
//
//  Created by Saharat Petcharayuttapan on 21/9/2565 BE.
//

import UIKit

protocol TextEditDragDropViewControllerDelegate: AnyObject {
    func onRequestDisplayOnTop()
    func onTapClose()
}

class TextEditDragDropViewController: UIViewController {

    deinit {
         NotificationCenter.default.removeObserver(self)
    }

    enum TextAlignmentType: Int {
        case left = 0
        case center = 1
        case right = 2
        case count = 3
    }

    enum StateType {
        case adding
        case editing
        case display
        case none
    }

    let fontsName: [String] = ["CSPraJad",
                               "MNPaethai",
                               "THMaliGrade6",
                               "ThaiSansNeue-Regular",
                               "NotoSansThai",
                               "NotoSansThai-Bold"]

    let fontsColor: [UIColor] =
    [
        UIColor.colorWithHexString("#FFFFFF"),
        UIColor.colorWithHexString("#1E1E1E"),
        UIColor.colorWithHexString("#FFFDD5"),
        UIColor.colorWithHexString("#F6E64C"),
        UIColor.colorWithHexString("#F7CE55"),
        UIColor.colorWithHexString("#FOA05A"),
        UIColor.colorWithHexString("#EA8147"),
        UIColor.colorWithHexString("#B93627"),
        UIColor.colorWithHexString("#B93627"),
        UIColor.colorWithHexString("#E059C1"),
        UIColor.colorWithHexString("#ED72B2"),
        UIColor.colorWithHexString("#F8BFEC"),
        UIColor.colorWithHexString("#DADOFB"),
        UIColor.colorWithHexString("#9268C6"),
        UIColor.colorWithHexString("#811896"),
        UIColor.colorWithHexString("#7504A7"),
        UIColor.colorWithHexString("#5F3694"),
        UIColor.colorWithHexString("#00007B"),
        UIColor.colorWithHexString("#2941A5"),
        UIColor.colorWithHexString("#3164D9"),
        UIColor.colorWithHexString("#508CFA"),
        UIColor.colorWithHexString("#467486"),
        UIColor.colorWithHexString("#4CA5A5"),
        UIColor.colorWithHexString("#8AD3D5"),
        UIColor.colorWithHexString("#4BA570"),
        UIColor.colorWithHexString("#72C580"),
        UIColor.colorWithHexString("#9FCE77"),
        UIColor.colorWithHexString("#D4E156"),
        UIColor.colorWithHexString("#CCCCC5"),
        UIColor.colorWithHexString("#B2B6B6"),
        UIColor.colorWithHexString("#73808E"),
        UIColor.colorWithHexString("#626262"),
        UIColor.colorWithHexString("#B6A285"),
        UIColor.colorWithHexString("#D2B132"),
        UIColor.colorWithHexString("#F2D17B"),
        UIColor.colorWithHexString("#EODFC8"),
        UIColor.colorWithHexString("#D7C8B3"),
        UIColor.colorWithHexString("#907752"),
        UIColor.colorWithHexString("#7E560B"),
        UIColor.colorWithHexString("#40300C")
    ]

    @IBOutlet weak var topExtendContentView: UIView!
    @IBOutlet weak var topContentView: UIView!
    @IBOutlet weak var fontContentView: UIView!
    @IBOutlet weak var displayContentView: UIView!
    @IBOutlet weak var closeButton: UIButton!
    @IBOutlet weak var viewCloseButton: UIView!
    @IBOutlet weak var alignmentButton: UIButton!
    @IBOutlet weak var colorButton: UIButton!
    @IBOutlet weak var editTextView: UITextView!
    @IBOutlet weak var confirmButton: UIButton!
    @IBOutlet weak var imageViewConfirmButton: UIImageView!

    @IBOutlet weak var fontStyleCollectionView: UICollectionView!
    @IBOutlet weak var fontColorCollectionView: UICollectionView!
    @IBOutlet weak var buttomFromSafeArea: NSLayoutConstraint!

    @IBOutlet weak var viewBackgroundColor: UIView!
    @IBOutlet weak var viewFrontColor: UIView!

    var locationSaved: [CGPoint] = []

    var displayedTexts: [DisplayLabelView] = []
    var movingItem: DisplayLabelView?
    var editingItem: DisplayLabelView?
    var currentTextAlignment: TextAlignmentType = .center
    var currentColor: UIColor = .white
    var currentState: StateType = .none
    var currentFont: UIFont?
    weak var delegate: TextEditDragDropViewControllerDelegate?

    var identity = CGAffineTransform.identity
    var oldCenter: CGPoint = .zero
    var beginTouch: CGPoint = .zero
    var thresholdValue: Int = 10

    override func viewDidLoad() {
        super.viewDidLoad()
        self.setup()

        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
    }

    @objc func keyboardWillShow(_ notification: Notification) {

        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
            self.buttomFromSafeArea.constant = 1.0 * (keyboardSize.size.height - self.view.safeAreaInsets.bottom)
            UIView.animate(withDuration: 0.3, animations: {
                self.view.layoutIfNeeded()
            })
        }
    }

    @objc func keyboardWillHide(_ notification: Notification) {
        self.buttomFromSafeArea.constant = 0
        UIView.animate(withDuration: 0.5, animations: {
            self.view.layoutIfNeeded()
        })
    }

    func setup() {
        self.addGesture()
        self.view.backgroundColor = .clear
        self.fontStyleCollectionView.delegate = self
        self.fontStyleCollectionView.dataSource = self

        self.fontColorCollectionView.delegate = self
        self.fontColorCollectionView.dataSource = self

        let fontNib = UINib(nibName: "FontStyleCollectionViewCell", bundle: nil)
        let colorNib = UINib(nibName: "FontColorCollectionViewCell", bundle: nil)

        self.fontStyleCollectionView.register(fontNib, forCellWithReuseIdentifier: "FontStyleCollectionViewCell")
        self.fontColorCollectionView.register(colorNib, forCellWithReuseIdentifier: "FontColorCollectionViewCell")

        self.editTextView.isHidden = false
        self.topContentView.isHidden = false
        self.topExtendContentView.isHidden = false
        self.fontContentView.isHidden = false
        self.fontColorCollectionView.isHidden = true

        self.alignmentButton.setImage(UIImage(systemName: "text.aligncenter"), for: .normal)
        self.viewBackgroundColor.clipsToBounds = true

        self.viewFrontColor.layer.borderWidth = 1
        self.viewFrontColor.layer.borderColor = UIColor.black.cgColor
        self.viewFrontColor.clipsToBounds = true

        self.fontContentView.backgroundColor = .clear
        self.fontStyleCollectionView.backgroundColor = .clear
        self.fontColorCollectionView.backgroundColor = .clear

        self.viewCloseButton.clipsToBounds = true
//        self.closeButton.setImage(UIImage(systemName: "xmark"), for: .normal)
//        self.closeButton.tintColor = .white
        //self.imageViewConfirmButton.image = UIImage(systemName: "checkmark.circle")
    }

    public func addNewText() {
        self.fontStyleCollectionView.reloadData()
        self.fontColorCollectionView.reloadData()
        self.setState(state: .adding)
    }

    public func exportTextImage(baseImage: UIImage? = nil) -> UIImage {
        for textDisplay in self.displayedTexts {
            textDisplay.hideUIForCapture(hidden: true)
        }

        let renderer = UIGraphicsImageRenderer(bounds: self.displayContentView.bounds)
        let textImage = renderer.image { rendererContext in
            self.displayContentView.layer.render(in: rendererContext.cgContext)
        }

        for textDisplay in self.displayedTexts {
            textDisplay.hideUIForCapture(hidden: false)
        }

        var merged = UIImage()
        if let bottomImage = baseImage {
            let topImage = textImage

            let size = bottomImage.size
            UIGraphicsBeginImageContext(size)

            let areaSize = CGRect(x: 0, y: 0, width: size.width, height: size.height)
            bottomImage.draw(in: areaSize)

            topImage.draw(in: areaSize, blendMode: .normal, alpha: 1)

            merged = UIGraphicsGetImageFromCurrentImageContext()!
            UIGraphicsEndImageContext()

            return merged
        }

        return textImage
    }

    func addNewLabelToDisplay() {

        guard !self.editTextView.text.isEmpty else {
            self.setState(state: .display)
            return
        }

        let newLabel = DisplayLabelView.commonInit()
        newLabel.settingLabel()
        newLabel.textLabel.text = self.editTextView.text
        newLabel.textLabel.textColor = self.currentColor
        newLabel.textLabel.font = self.editTextView.font
        newLabel.currentAlignment = self.currentTextAlignment
        newLabel.color = self.currentColor
        switch newLabel.currentAlignment {
        case .center:
            newLabel.textLabel.textAlignment = .center

        case .left:
            newLabel.textLabel.textAlignment = .left

        case .right:
            newLabel.textLabel.textAlignment = .right

        case .count:
            break
            // do nothing
        }

        newLabel.onRemovePressedCompletion = { [weak self] label in
            self?.deleteLabel(label: label)
        }

        newLabel.textLabel.sizeToFit()

        self.displayedTexts.append(newLabel)
        self.displayContentView.addSubview(newLabel)

        self.setState(state: .display)
    }

    private func deleteLabel(label: DisplayLabelView) {
        if let index = self.displayedTexts.firstIndex(of: label) {
            self.displayedTexts.remove(at: index)
        }
        self.saveLocationState()
        label.removeFromSuperview()
        self.applyLocationState()
    }

    func saveLocationState() {
        self.locationSaved = self.displayedTexts.map({ $0.frame.origin })
    }

    func applyLocationState() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.001, execute: {
            for (indexing, text) in self.displayedTexts.enumerated() {
                if indexing < self.locationSaved.count {
                    text.frame.origin = self.locationSaved[indexing]
                }
            }
        })
    }

    func updateLabelToDisplay() {

        if let editing = self.editingItem {
            if self.editTextView.text.isEmpty {
                self.deleteLabel(label: editing)
                self.setState(state: .display)
            } else {
                editing.currentAlignment = self.currentTextAlignment
                editing.color = self.currentColor

                editing.textLabel.text = self.editTextView.text
                editing.textLabel.numberOfLines = 0
                editing.textLabel.textColor = self.currentColor
                editing.textLabel.font = self.editTextView.font
                editing.currentAlignment = self.currentTextAlignment

                switch editing.currentAlignment {
                case .center:
                    editing.textLabel.textAlignment = .center

                case .left:
                    editing.textLabel.textAlignment = .left

                case .right:
                    editing.textLabel.textAlignment = .right

                case .count:
                    break
                    // do nothing
                }
                editing.sizeToFit()
                self.setState(state: .display)
            }
        }
    }

    func setState(state: StateType) {

        self.currentState = state
        switch self.currentState {
        case .adding:
            self.saveLocationState()
            for text in self.displayedTexts {
                text.isHidden = true
            }

            self.editTextView.isHidden = false
            self.topContentView.isHidden = false
            self.topExtendContentView.isHidden = false
            self.fontContentView.isHidden = false

            self.editTextView.becomeFirstResponder()

            self.editingItem = nil
            self.editTextView.text = ""

            self.viewBackgroundColor.backgroundColor = .white
            self.currentColor = self.fontsColor.first ?? .white
            self.currentFont = UIFont(name: self.fontsName.first ?? "",
                                      size: self.editTextView.font?.pointSize ?? 0)
            self.editTextView.textColor = self.currentColor
            self.editTextView.font = self.currentFont

            self.viewFrontColor.backgroundColor = self.currentColor
            self.view.backgroundColor = .black.withAlphaComponent(0.5)
            self.setSelected()

            break

        case .editing:
            self.saveLocationState()

            for text in self.displayedTexts {
                text.isHidden = true
            }
            self.editTextView.isHidden = false
            self.topContentView.isHidden = false
            self.topExtendContentView.isHidden = false
            self.fontContentView.isHidden = false

            self.editTextView.becomeFirstResponder()
            self.editTextView.text = self.editingItem?.textLabel.text
            self.editTextView.font = self.editingItem?.textLabel.font
            self.editTextView.textColor = self.editingItem?.color
            self.currentColor = self.editingItem?.color ?? .white
            self.viewFrontColor.backgroundColor = self.currentColor
            self.view.backgroundColor = .black.withAlphaComponent(0.5)
            self.delegate?.onRequestDisplayOnTop()
            self.setSelected()

            break

        case .display:
            self.applyLocationState()
            for text in self.displayedTexts {
                text.isHidden = false
            }
            self.editTextView.isHidden = true
            self.topContentView.isHidden = true
            self.topExtendContentView.isHidden = true
            self.fontContentView.isHidden = true

            self.editTextView.resignFirstResponder()
            self.view.backgroundColor = .clear

            break

        case .none:
            break
        }
    }

    private func setSelected() {

        // set selected font
        if let firstIndex = fontsName.firstIndex(where: { $0 == self.currentFont?.fontName }) {
            let indexPath = IndexPath(row: firstIndex, section: 0)
            fontStyleCollectionView.selectItem(at: indexPath, animated: false, scrollPosition: .centeredHorizontally)
        }

        // set selected color
        if let firstIndex = fontsColor.firstIndex(where: { $0 == self.currentColor }) {
            let indexPath = IndexPath(row: firstIndex, section: 0)
            fontColorCollectionView.selectItem(at: indexPath, animated: false, scrollPosition: .centeredHorizontally)
        }
    }

    @IBAction func closeButtonPressed(_ sender: Any) {
        self.setState(state: .display)
        delegate?.onTapClose()
    }

    @IBAction func alignmentButtonPressed(_ sender: Any) {
        let current = self.currentTextAlignment.rawValue
        self.currentTextAlignment = TextAlignmentType.init(rawValue: (current + 1) % TextAlignmentType.count.rawValue) ?? .center

        switch self.currentTextAlignment {
        case .center:
            self.editTextView.textAlignment = .center
            self.alignmentButton.setImage(UIImage(systemName: "text.aligncenter"), for: .normal)

        case .left:
            self.editTextView.textAlignment = .left
            self.alignmentButton.setImage(UIImage(systemName: "text.alignleft"), for: .normal)

        case .right:
            self.editTextView.textAlignment = .right
            self.alignmentButton.setImage(UIImage(systemName: "text.alignright"), for: .normal)

        case .count:
            break
            // do nothing
        }
    }

    @IBAction func colorButtonPressed(_ sender: Any) {
        self.viewBackgroundColor.backgroundColor = self.fontColorCollectionView.isHidden ? UIColor.red : .white
        self.fontColorCollectionView.isHidden.toggle()
        self.fontStyleCollectionView.isHidden.toggle()
    }

    @IBAction func confirmButtonPressed(_ sender: Any) {
        if let _ = self.editingItem {
            self.updateLabelToDisplay()
        } else {
            self.addNewLabelToDisplay()
        }
        delegate?.onTapClose()
    }
}

extension TextEditDragDropViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == self.fontStyleCollectionView {
            return self.fontsName.count
        } else if collectionView == self.fontColorCollectionView {
            return self.fontsColor.count
        }
        return 0
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {

        if collectionView == self.fontStyleCollectionView {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "FontStyleCollectionViewCell", for: indexPath) as! FontStyleCollectionViewCell
            cell.setFontName(fontName: self.fontsName[indexPath.row])
            return cell
        } else if collectionView == self.fontColorCollectionView {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "FontColorCollectionViewCell", for: indexPath) as! FontColorCollectionViewCell
            cell.setColor(color: self.fontsColor[indexPath.row])
            return cell
        }

        return UICollectionViewCell()
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if collectionView == self.fontStyleCollectionView {
            self.editTextView.font = UIFont(name: self.fontsName[indexPath.row], size: self.editTextView.font?.pointSize ?? 0)
            self.currentFont = UIFont(name: self.fontsName[indexPath.row], size: self.editTextView.font?.pointSize ?? 0)
        } else if collectionView == self.fontColorCollectionView {
            self.currentColor = self.fontsColor[indexPath.row]
            self.viewFrontColor.backgroundColor = self.currentColor
            self.editTextView.textColor = self.currentColor
        }
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 10
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 10
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return .init(top: 10, left: 20, bottom: 10, right: 20)
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 40, height: 40)
    }
}
