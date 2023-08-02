//
//  CreateShortVideoViewController.swift
//  ob_intern
//
//  Created by Soft Liampisan on 8/6/2566 BE.
//  Copyright (c) 2566 BE ___ORGANIZATIONNAME___. All rights reserved.

import UIKit
import AVKit
import AVFoundation


class CreateShortVideoViewController: UIViewController {

    //MARK: - New Instance
    class func newInstance(asset: AVAsset? = nil) -> CreateShortVideoViewController {
        let viewController = CreateShortVideoViewController(nibName: String(describing: CreateShortVideoViewController.self),
                                                       bundle: nil)
        
        
        let viewModel = CreateShortVideoViewModel(delegate: viewController, asset: asset)
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
    var progressBar: UploadVideoProgressbar?
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
        self.setData()
        
    }
    
    //MARK: - Functions
    func setupView() {
        textViewThoughts.delegate = self
        textViewThoughts.text = "Share your thoughts within 2000 characters"
        textViewThoughts.textColor = UIColor.lightGray
        
        imageViewVideo.layer.cornerRadius = 16
        imageViewVideo.clipsToBounds = true
        
        labelChooseFrontCover.layer.cornerRadius = 12
        labelChooseFrontCover.clipsToBounds = true
        self.navigationController?.setNavigationBarHidden(true, animated: false)
        buttonPost.layer.cornerRadius = 10
        buttonPost.setTitle("โพสต์", for: .normal)
        buttonPost.setTitle("", for: .disabled)
        buttonPost.addSubview(spinner)
        spinner.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            spinner.centerXAnchor.constraint(equalTo: buttonPost.centerXAnchor),
            spinner.centerYAnchor.constraint(equalTo: buttonPost.centerYAnchor)
        ])
        dismissEditing()
     
    }
    
    func setUpProgressbar(){
        progressBar = UploadVideoProgressbar(frame: .init(x: 10, y: 70, width: UIScreen.main.bounds.width - 20, height: 56))
        progressBar?.layoutIfNeeded()
        guard let progressBar = progressBar else { return }
        self.view.addSubview(progressBar)
        progressBar.state = .loading
    }
    
    func setData() {
        imageViewVideo.sd_setImage(with: URL(string: "https://images3.alphacoders.com/110/1108129.jpg"))
    }
    
    func updateLoadingIndicator() {
        if isLoading {
            spinner.startAnimating()
            buttonPost.isEnabled = false
            buttonPost.backgroundColor = .systemGray4
        } else {
            spinner.stopAnimating()
            buttonPost.isEnabled = true
        }
    }
    
    @objc func handleTapDismiss(_ sender: UITapGestureRecognizer? = nil) {
        view.endEditing(true)
    }
    
    func dismissEditing() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(self.handleTapDismiss(_:)))
        view.addGestureRecognizer(tap)
        view.isUserInteractionEnabled = true
    }
    
    private func setSwitchStatus(switchView: UISwitch, label: UILabel, textSwitchOn: String, textSwitchOff: String){
        label.text = switchView.isOn ? textSwitchOn : textSwitchOff
    }
    
    

    //MARK: - Action
    @IBAction func buttonChooseFrontCoverAction(_ sender: UISwitch) {
        let controller = EditShortVideoCoverViewController.newInstance()
        self.navigationController?.pushViewController(controller, animated: true)
    }
    
    @IBAction func buttonBackAction(_ sender: Any) {
        self.dismiss(animated: true)
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func buttonPostAction(_ sender: Any) {
        viewModel?.createShortVDO(coverImageURL: "",
                                  caption: textViewThoughts.text,
                                  isAllowComments: switchAllowComments.isOn,
                                  isPublic: switchStatus.isOn,
                                  isAllowGifts: switchReceiveGifts.isOn)
        
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
    func isPostSuccess() {
//        self.navigationController?.popViewController(animated: true)
//        self.dismiss(animated: true)
        guard let asset = viewModel?.asset as? AVURLAsset else { return }
        let controller = ShortVideoPlayerViewController.newInstance(post: ShortVideoPost.mock(),
                                                                    asset: asset)
        self.navigationController?.pushViewController(controller, animated: true)
    }
    
    func showSuccessPost() {
        let alert = UIAlertController(title: "Success", message: "Your post has been uploaded", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { [weak self]
            (action) in
            self?.isPostSuccess()
        }))
        self.present(alert, animated: true, completion: nil)
    }
    
    func showError(error: Error) {
        let alert = UIAlertController(title: "Error", message: "Oops, something went wrong. Please try again later.", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
    }
    
    func showLoading() {
        self.isLoading = true
        setUpProgressbar()
    }
    
    func hideLoading() {
        self.isLoading = false
        progressBar?.state = .success
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


