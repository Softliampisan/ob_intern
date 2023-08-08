//
//  CreateMenuViewController.swift
//  ob_intern
//
//  Created by Soft Liampisan on 27/7/2566 BE.
//  Copyright (c) 2566 BE ___ORGANIZATIONNAME___. All rights reserved.

import UIKit

class CreateMenuViewController: UIViewController {

    //MARK: - New Instance
    class func newInstance() -> CreateMenuViewController {
        let viewController = CreateMenuViewController(nibName: String(describing: CreateMenuViewController.self),
                                                       bundle: nil)
        let viewModel = CreateMenuViewModel()
        viewController.viewModel = viewModel
        
        return viewController
    }
    
    //MARK: - IBOutlet
    @IBOutlet weak var buttonCreateShort: UIButton!
    @IBOutlet weak var viewCreate: UIView!
    @IBOutlet weak var viewBlackBackground: UIView!
    
    //MARK: - Parameters
    private var viewModel: CreateMenuViewModel?
    
    //MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupView()
    }
    
    //MARK: - Functions
    func setupView() {
        buttonCreateShort.layer.cornerRadius = buttonCreateShort.frame.size.width / 2
        buttonCreateShort.clipsToBounds = true
        viewCreate.layer.cornerRadius = 16
        viewCreate.clipsToBounds = true
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(viewTapped))
        viewBlackBackground.addGestureRecognizer(tapGesture)
        viewBlackBackground.isUserInteractionEnabled = true
    }
    
    @objc func viewTapped() {
        self.dismiss(animated: true)
    }
    
    
    //MARK: - Action
    @IBAction func buttonCreateShortAction(_ sender: Any) {
        self.dismiss(animated: true) {
            AppDirector.sharedInstance().displayStampLogoVideoViewController()
        }
    }
    
}

extension CreateMenuViewController: CreateMenuViewModelDelegate {
    
    func showError(error: Error) {
        
    }
    
    func showLoading() {
        
    }
    
    func hideLoading() {
        
    }
    
}

