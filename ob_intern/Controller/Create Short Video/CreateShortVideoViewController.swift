//
//  CreateShortVideoViewController.swift
//  ob_intern
//
//  Created by Soft Liampisan on 8/6/2566 BE.
//  Copyright (c) 2566 BE ___ORGANIZATIONNAME___. All rights reserved.

import UIKit

class CreateShortVideoViewController: UIViewController {

    //MARK: - New Instance
    class func newInstance() -> CreateShortVideoViewController {
        let viewController = CreateShortVideoViewController(nibName: String(describing: CreateShortVideoViewController.self),
                                                       bundle: nil)
        
        
        let viewModel = CreateShortVideoViewModel(delegate: viewController)
        viewController.viewModel = viewModel
        
        return viewController
    }
    
    //MARK: - IBOutlet
    @IBOutlet weak var textViewThoughts: UITextView!
    @IBOutlet weak var imageViewVideo: UIImageView!
    @IBOutlet weak var labelSwitchAllowComments: UILabel!
    @IBOutlet weak var labelSwitchStatus: UILabel!
    @IBOutlet weak var labelSwitchReceiveGifts: UILabel!
    @IBOutlet weak var labelAllowComments: UILabel!
    @IBOutlet weak var labelStatus: UILabel!
    @IBOutlet weak var labelReceiveGifts: UILabel!
    @IBOutlet weak var labelChooseFrontCover: PaddingLabel!
    @IBOutlet weak var buttonChooseFrontCover: UIButton!
    @IBOutlet weak var buttonBack: UIButton!
    @IBOutlet weak var buttonPost: UIButton!
    @IBOutlet weak var switchAllowComments: UISwitch!
    @IBOutlet weak var switchStatus: UISwitch!
    @IBOutlet weak var switchReceiveGifts: UISwitch!
    
    
    //MARK: - Parameters
    private var viewModel: CreateShortVideoViewModel?
    private let MAX_CHARACTERS = 2000
    private var PLACEHOLDER_TEXT_COLOR: UIColor = .lightGray
    var spinner = UIActivityIndicatorView()
    var isLoading = false {
        didSet {
            // whenever `isLoading` state is changed, update the view
            updateLoadingIndicator()
        }
    }
    
    //MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupView()
        
    }
    
    //MARK: - Functions
    func setupView() {
        textViewThoughts.delegate = self
        textViewThoughts.text = "Share your thoughts within 2000 characters"
        textViewThoughts.textColor = UIColor.lightGray
        imageViewVideo.layer.cornerRadius = 16
        imageViewVideo.clipsToBounds = true
        imageViewVideo.sd_setImage(with: URL(string: "https://images3.alphacoders.com/110/1108129.jpg"))
        labelChooseFrontCover.layer.cornerRadius = 12
        labelChooseFrontCover.clipsToBounds = true
        self.navigationController?.setNavigationBarHidden(true, animated: false)
        setButtonImage(imageName: "chevron.left",
                       iconColor: .black,
                       button: buttonBack)
        buttonPost.setTitle("โพสต์", for: .normal)

        buttonPost.addSubview(spinner)
        spinner.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            spinner.centerXAnchor.constraint(equalTo: buttonPost.centerXAnchor),
            spinner.centerYAnchor.constraint(equalTo: buttonPost.centerYAnchor)
        ])
        dismissEditing()
     
    }
    
    func updateLoadingIndicator() {
        if isLoading {
            spinner.startAnimating()
            buttonPost.isEnabled = false
            buttonPost.setTitle(" ", for: .disabled)
        } else {
            spinner.stopAnimating()
            buttonPost.isEnabled = true
        }
    }
    
    @objc func handleTap(_ sender: UITapGestureRecognizer? = nil) {
        view.endEditing(true)
    }
    
    func dismissEditing() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(self.handleTap(_:)))
        view.addGestureRecognizer(tap)
        view.isUserInteractionEnabled = true
    }
    
    private func setSwitchStatus(switchView: UISwitch, label: UILabel, textSwitchOn: String, textSwitchOff: String){
        label.text = switchView.isOn ? textSwitchOn : textSwitchOff
    }
    
    func setButtonImage(imageName: String? = nil,
                        iconColor: UIColor,
                        button: UIButton){
        
        if let imageName = imageName,
           let image = UIImage(systemName: imageName) {
            
            let colorImage = image.withTintColor(iconColor, renderingMode: .alwaysOriginal)
            button.setImage(colorImage, for: .normal)
            
        }
    }
    

    //MARK: - Action
    @IBAction func buttonChooseFrontCoverAction(_ sender: UISwitch) {
    }
    
    @IBAction func buttonBackAction(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func buttonPostAction(_ sender: Any) {
        self.isLoading = true
        DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(2)) {
            self.navigationController?.popViewController(animated: true)
            self.isLoading = false
        }
    }
    
    
    @IBAction func switchAllowCommentsAction(_ sender: UISwitch) {
        self.setSwitchStatus(switchView: sender,
                             label: labelSwitchAllowComments,
                             textSwitchOn: "ได้",
                             textSwitchOff: "ไม่ได้")
    }
    
    @IBAction func switchStatusAction(_ sender: UISwitch) {

        self.setSwitchStatus(switchView: sender,
                             label: labelSwitchStatus,
                             textSwitchOn: "เผยแพร่",
                             textSwitchOff: "ซ่อน")
    }
    
    
    @IBAction func switchReceiveGiftsAction(_ sender: UISwitch) {
        self.setSwitchStatus(switchView: sender,
                             label: labelSwitchReceiveGifts,
                             textSwitchOn: "รับ",
                             textSwitchOff: "ไม่รับ")
    }
    
   
}

extension CreateShortVideoViewController: CreateShortVideoViewModelDelegate {
    
    func showError(error: Error) {
        
    }
    
    func showLoading() {
        
    }
    
    func hideLoading() {
        
    }
    
}


extension CreateShortVideoViewController: UITextViewDelegate{
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {

        let currentText = textView.text as NSString
        let newText = currentText.replacingCharacters(in: range, with: text)
        let numberOfChars = newText.count

        if numberOfChars > MAX_CHARACTERS {
            let truncatedText = String(newText.prefix(MAX_CHARACTERS))
            textView.text = truncatedText
            return false
        }
        return true
    }
   
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.textColor == PLACEHOLDER_TEXT_COLOR {
            textView.text = nil
            textView.textColor = UIColor.black
        }
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text.isEmpty {
            textView.text = "Share your thoughts within 2000 characters"
            textView.textColor = PLACEHOLDER_TEXT_COLOR
        }
    }
    
}


