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
    @IBOutlet weak var switchAllowComments: UISwitch!
    @IBOutlet weak var switchStatus: UISwitch!
    @IBOutlet weak var switchReceiveGifts: UISwitch!
    
    //MARK: - Parameters
    private var viewModel: CreateShortVideoViewModel?
    private let MAX_CHARACTERS = 2000
    private var PLACEHOLDER_TEXT_COLOR: UIColor = .lightGray
    
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
        imageViewVideo.sd_setImage(with: URL(string: "https://images.unsplash.com/photo-1609171712489-45b6ba7051a4?ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxzZWFyY2h8M3x8c3Vuc2V0JTIwYWVzdGhldGljfGVufDB8fDB8fHww&auto=format&fit=crop&w=800&q=60"))
        labelChooseFrontCover.layer.cornerRadius = 12
        labelChooseFrontCover.clipsToBounds = true
        navigationItem.hidesBackButton = true
        
     
    }
    
    private func setSwitchStatus(switchView: UISwitch, label: UILabel, textSwitchOn: String, textSwitchOff: String){
        if switchView.isOn {
            label.text = textSwitchOn
        } else {
            label.text = textSwitchOff
        }
    }
    

    
    //MARK: - Action
    
    @IBAction func buttonChooseFrontCoverAction(_ sender: UISwitch) {
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


