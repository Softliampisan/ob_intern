//
//  UploadVideoProgressbar.swift
//  ob_intern
//
//  Created by Soft Liampisan on 12/6/2566 BE.
//

import UIKit
import Foundation

class UploadVideoProgressbar: InitializeXibView {
    
    enum ProgressBarState {
        case success
        case loading
        case fail
    }
    
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var shadowView: UIView!
    @IBOutlet weak var viewContainImageLabel: UIView!
    @IBOutlet weak var viewContainProgress: UIView!
    @IBOutlet weak var horizontalStackView: UIStackView!
    @IBOutlet weak var verticalStackView: UIStackView!
    @IBOutlet weak var label: UILabel!
    @IBOutlet weak var imageViewFail: UIImageView!
    @IBOutlet weak var progressView: UIProgressView!
    
    private var progress: Float = 0.0
    private var timer: Timer?
    var state: ProgressBarState = .loading {
        didSet {
            //check which state and perform function
            if state == .success {
                setSuccessLabel()
            }
            if state == .fail {
                setFailureLabel()
            }
            if state == .loading {
                setLoadingLabel()
                uploadVideo()

            }
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setUpValues()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setUpValues()
    }
    
    private func setUpValues() {
        setupContainerView()
        setupLabelandImage()
        setupProgressView()
    }
    
    private func setupContainerView() {

        containerView.layer.borderColor = UIColor.systemGray5.cgColor
        containerView.layer.borderWidth = 1.0
        containerView.layer.cornerRadius = 10
        containerView.layer.masksToBounds = true
        shadowView.layer.shadowColor = UIColor.systemGray5.cgColor
        shadowView.layer.shadowOffset = CGSize(width: 3, height: 3)
        shadowView.layer.shadowOpacity = 0.7
        shadowView.layer.shadowRadius = 10.0
        
        self.addSubview(shadowView)
        shadowView.addSubview(containerView)
        containerView.addSubview(verticalStackView)
        verticalStackView.addSubview(viewContainImageLabel)
        
        NSLayoutConstraint.activate([
            containerView.topAnchor.constraint(equalTo: topAnchor),
            containerView.leadingAnchor.constraint(equalTo: leadingAnchor),
            containerView.trailingAnchor.constraint(equalTo: trailingAnchor),
            containerView.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
    }
    
    private func setupLabelandImage() {
        label.textColor = .black
        label.font = UIFont.systemFont(ofSize: 16.0)
        horizontalStackView.addSubview(label)
        horizontalStackView.addSubview(imageViewFail)
        viewContainImageLabel.addSubview(horizontalStackView)
        imageViewFail.isHidden = true

    }
    
    private func setSuccessLabel() {
        label.text = "Short VDO ของคุณอัปโหลดสำเร็จแล้ว"
        label.textColor = .black
        viewContainProgress.isHidden = true
        imageViewFail.isHidden = true
    }
    
    private func setLoadingLabel() {
        label.text = "กำลังอัปโหลด Short VDO ของคุณ"
        label.textColor = .black
        imageViewFail.isHidden = true
        viewContainProgress.isHidden = false

    }
    
    private func setFailureLabel() {
        label.text = "Short VDO ของคุณอัปโหลดไม่สำเร็จ"
        label.textColor = .red
        viewContainProgress.isHidden = true
        imageViewFail.isHidden = false

    }
    
    private func setupProgressView() {
        viewContainProgress.addSubview(progressView)
        verticalStackView.addSubview(viewContainProgress)
    }
    
    func uploadVideo() {
        // Stop any existing timer
        stopUpdatingProgress()
        progress = 0.0
        progressView.progress = progress
  
        timer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(updateProgress), userInfo: nil, repeats: true)
    }
    
    func stopUpdatingProgress() {
        timer?.invalidate()
        timer = nil
    }
    
    func handleFailure() {
        stopUpdatingProgress()
        setFailureLabel()
    }
    
    @objc private func updateProgress() {
        progress += 0.1
        if progress > 1.0 {
            progressView.progress = 1.0
            stopUpdatingProgress()
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                self.setSuccessLabel()
            }
            
        } else {
            progressView.progress = progress
        }
    }
    
    
}

