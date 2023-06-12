//
//  UploadVideoProgressbar.swift
//  ob_intern
//
//  Created by Soft Liampisan on 12/6/2566 BE.
//

import UIKit
import Foundation

class UploadVideoProgressbar: UIView {
    
    private let containerView: UIView = UIView()
    private let label: UILabel = UILabel()
    private let progressView: UIProgressView = UIProgressView()
    private var progress: Float = 0.0
    private var timer: Timer?
    
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
        containerView.translatesAutoresizingMaskIntoConstraints = false
        containerView.layer.borderColor = UIColor.lightGray.cgColor
        containerView.layer.borderWidth = 1.0
        containerView.layer.cornerRadius = 10
        addSubview(containerView)
        
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
        label.textAlignment = .center
        
        containerView.addSubview(label)
    }
    
    private func setupProgressView() {
        progressView.translatesAutoresizingMaskIntoConstraints = false
        containerView.addSubview(progressView)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        // Update the frame of the label and progress view within the container view
        label.frame = CGRect(x: 0, y: 0, width: containerView.bounds.width, height: 20.0)
        progressView.frame = CGRect(x: 0, y: label.frame.maxY + 8.0, width: containerView.bounds.width, height: 4.0)
    }
    
    func setProgress(_ progress: Float) {
        progressView.progress = progress
    }
    
    
}

