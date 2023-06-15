//
//  TestProgressBarViewController.swift
//  ob_intern
//
//  Created by Soft Liampisan on 14/6/2566 BE.
//  Copyright (c) 2566 BE ___ORGANIZATIONNAME___. All rights reserved.

import UIKit

class TestProgressBarViewController: UIViewController {

    //MARK: - New Instance
    class func newInstance() -> TestProgressBarViewController {
        let viewController = TestProgressBarViewController(nibName: String(describing: TestProgressBarViewController.self),
                                                       bundle: nil)
        
        let viewModel = TestProgressBarViewModel(delegate: viewController)
        viewController.viewModel = viewModel
        
        return viewController
    }
    
    //MARK: - IBOutlet
    @IBOutlet weak var progressBarView: UIView!
    @IBOutlet weak var buttonTestSuccess: UIButton!
    @IBOutlet weak var buttonTestLoading: UIButton!
    @IBOutlet weak var buttonTestFailure: UIButton!

    //MARK: - Parameters
    private var viewModel: TestProgressBarViewModel?
    var progressBar: UploadVideoProgressbar!
    
    //MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupView()
    }
    
    //MARK: - Functions
    func setupView() {
        progressBar = UploadVideoProgressbar(frame: .init(x: 8, y: 70, width: self.view.bounds.width, height: 56))
        print("containerview \(progressBar.containerView.bounds.width)")
        progressBar.layoutIfNeeded()
        self.view.addSubview(progressBar)
        progressBar.state = .loading

    }
    
    //MARK: - Action
    @IBAction func buttonTestSuccessAction(_ sender: Any) {
        progressBar.state = .success
    }
    
    @IBAction func buttonTestFailAction(_ sender: Any) {
        progressBar.state = .fail
    }
    
    @IBAction func buttonTestLoadAction(_ sender: Any) {
        progressBar.state = .loading
    }
    
    
    
    
}

extension TestProgressBarViewController: TestProgressBarViewModelDelegate {
    
    func showError(error: Error) {
        
    }
    
    func showLoading() {
        
    }
    
    func hideLoading() {
        
    }
    
}

