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
    @IBOutlet weak var stackView: UIStackView!
//    @IBOutlet weak var verticalStackView: UIStackView!
    @IBOutlet weak var shadowView: UIView!
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
        setupLabel()
        setupProgressView()
    }
    
    private func setupContainerView() {
//        containerView.translatesAutoresizingMaskIntoConstraints = false
        containerView.layer.borderColor = UIColor.systemGray4.cgColor
        containerView.layer.borderWidth = 1.0
        containerView.layer.cornerRadius = 10
        containerView.layer.masksToBounds = true
        shadowView.layer.shadowColor = UIColor.systemGray4.cgColor
        shadowView.layer.shadowOffset = CGSize(width: 3, height: 3)
        shadowView.layer.shadowOpacity = 0.7
        shadowView.layer.shadowRadius = 10.0
        self.addSubview(shadowView)
        shadowView.addSubview(containerView)
        containerView.addSubview(stackView)
        NSLayoutConstraint.activate([
            containerView.topAnchor.constraint(equalTo: topAnchor),
            containerView.leadingAnchor.constraint(equalTo: leadingAnchor),
            containerView.trailingAnchor.constraint(equalTo: trailingAnchor),
            containerView.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
    }
    
    private func setupLabel() {
        label.textColor = .black
        label.font = UIFont.systemFont(ofSize: 16.0)
//        label.textAlignment = .center
        stackView.addSubview(label)
        stackView.addSubview(imageViewFail)
//        verticalStackView.addSubview(horizontalStackView)
        imageViewFail.isHidden = true

    }
    
    private func setSuccessLabel() {
//        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Short VDO ของคุณอัปโหลดสำเร็จแล้ว"
        label.textColor = .black
        //label.center = self.view.center
        if progressView != nil && progressView.isDescendant(of: containerView) {
            progressView.removeFromSuperview()
        }
        imageViewFail.isHidden = true
    }
    
    private func setFailureLabel() {
        label.text = "Short VDO ของคุณอัปโหลดไม่สำเร็จ"
        label.textColor = .red
        //label.center = self.view.center
        if progressView != nil && progressView.isDescendant(of: containerView) {
            progressView.removeFromSuperview()
        }
        imageViewFail.isHidden = false

    }
    
    private func setupProgressView() {
//        progressView.translatesAutoresizingMaskIntoConstraints = false
        containerView.addSubview(progressView)
    }
    
    
    func setProgress(_ progress: Float) {
        progressView.progress = progress
    }
    
    
}

