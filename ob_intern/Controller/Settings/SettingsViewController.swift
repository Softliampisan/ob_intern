//
//  SettingsViewController.swift
//  ob_intern
//
//  Created by Soft Liampisan on 27/7/2566 BE.
//  Copyright (c) 2566 BE ___ORGANIZATIONNAME___. All rights reserved.

import UIKit

class SettingsViewController: UIViewController {

    //MARK: - New Instance
    class func newInstance() -> SettingsViewController {
        let viewController = SettingsViewController(nibName: String(describing: SettingsViewController.self),
                                                       bundle: nil)
        
        let viewModel = SettingsViewModel(delegate: viewController)
        viewController.viewModel = viewModel
        
        return viewController
    }
    
    //MARK: - IBOutlet
    @IBOutlet weak var isMockSwitch: UISwitch!
    @IBOutlet weak var buttonBack: UIButton!
    
    //MARK: - Parameters
    private var viewModel: SettingsViewModel?
    
    //MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupView()
        isMockSwitch.isOn = ShortVideoManager.isMock
    }
    
    //MARK: - Functions
    func setupView() {
        
    }
    
    //MARK: - Action
    
    @IBAction func buttonBackAction(_ sender: Any) {
        AppDirector.sharedInstance().rootViewController?.dismiss(animated: true)
    }
    
    @IBAction func isMockSwitchAction(_ sender: Any) {
        ShortVideoManager.isMock = isMockSwitch.isOn
    }
    
}

extension SettingsViewController: SettingsViewModelDelegate {
    
    func showError(error: Error) {
        
    }
    
    func showLoading() {
        
    }
    
    func hideLoading() {
        
    }
    
}

