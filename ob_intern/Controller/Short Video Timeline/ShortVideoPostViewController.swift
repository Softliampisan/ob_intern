//
//  ShortVideoPostViewController.swift
//  ob_intern
//
//  Created by Soft Liampisan on 15/6/2566 BE.
//  Copyright (c) 2566 BE ___ORGANIZATIONNAME___. All rights reserved.

import UIKit
import AVFoundation

//ondismiss
class ShortVideoPostViewController: UIViewController {

    //MARK: - New Instance
    class func newInstance() -> ShortVideoPostViewController {
        let viewController = ShortVideoPostViewController(nibName: String(describing: ShortVideoPostViewController.self),
                                                       bundle: nil)
        
        let viewModel = ShortVideoPostViewModel(delegate: viewController)
        viewController.viewModel = viewModel
        
        return viewController
    }
    
    //MARK: - IBOutlet
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var buttonBack: UIButton!
    
    //MARK: - Parameters
    private var viewModel: ShortVideoPostViewModel?
    private var activityView = UIActivityIndicatorView(style: .large)
    var createButton: CreatePostButtonView?
    let refresher = UIRefreshControl()
    
    //MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupView()
        self.viewModel?.getVideoPost()
        self.tableView.reloadData()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        ShortVideoManager.isMute = false
        ShortVideoManager.isFirstLoad = true
        playVideo()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        pauseVideo()
    }
    
    //MARK: - Functions
    func setupView() {
        tableView.dataSource = self
        tableView.delegate = self
        let nibName = String(describing: ShortVideoPostTableViewCell.self)
        tableView.register(UINib(nibName: nibName, bundle: nil), forCellReuseIdentifier: nibName)
        tableView.estimatedRowHeight = 700
        tableView.rowHeight = UITableView.automaticDimension
        refresher.tintColor = UIColor.red
        refresher.addTarget(self, action: #selector(reloadData), for: .valueChanged)
        tableView.addSubview(refresher)
        self.navigationController?.setNavigationBarHidden(true, animated: false)
        setupCreateButton()
        
    }
    
    @objc func reloadData() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) { [weak self] in
            self?.viewModel?.getVideoPost()
            self?.tableView.reloadData()
            self?.refresher.endRefreshing()
        }
    }
    
    func setupCreateButton() {
        createButton = CreatePostButtonView(frame: .init(x: UIScreen.main.bounds.width - 50 - 16, y: UIScreen.main.bounds.height - 50 - 100, width: 50, height: 50))
        if let createButton = createButton {
            self.view.addSubview(createButton)
        }
        createButton?.delegate = self
        
    }
    
    func showActivityIndicator() {
        self.activityView = UIActivityIndicatorView(style: .large)
        self.activityView.center = self.view.center
        self.view.addSubview(self.activityView)
        self.activityView.startAnimating()
        
    }
    
    func hideActivityIndicator() {
        self.activityView.stopAnimating()
        self.activityView.removeFromSuperview()
    }
    
    func pauseVideo() {
        if let indexPath = tableView.indexPathForRow(at: tableView.bounds.center) {
            if let cell = tableView.cellForRow(at: indexPath) as? ShortVideoPostTableViewCell {
                cell.pauseVideo()
            }
        }
    }
    
    func playVideo() {
        if let indexPath = tableView.indexPathForRow(at: tableView.bounds.center) {
            if let cell = tableView.cellForRow(at: indexPath) as? ShortVideoPostTableViewCell {
                cell.playVideo()
            }
        }
    }
    

    
    //MARK: - Action
    @IBAction func buttonBackAction(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
        self.dismiss(animated: true, completion: nil)
    }
    
}

extension ShortVideoPostViewController: ShortVideoPostViewModelDelegate {
    func showAlert(alert: UIAlertController) {
        self.present(alert, animated: true, completion: nil)
    }
    
    func updateData() {
        tableView.reloadData()
    }
    
    
    func showError(error: Error) {
        
    }
    
    func showLoading() {
        self.showActivityIndicator()
    }
    
    func hideLoading() {
        self.hideActivityIndicator()
    }
    
}

extension ShortVideoPostViewController: ShortVideoPostTableViewCellDelegate {
    func tapVideo(post: ShortVideoPost, currentTime: CMTime) {
        let controller = ShortVideoPlayerViewController.newInstance(post: post)
        controller.currentTime = currentTime
        controller.delegate = self 
        self.navigationController?.pushViewController(controller, animated: true)
        pauseVideo()
    }
    
    func tapProfileAction(post: ShortVideoPost) {
        let controller = ShortVideoListViewController.newInstance(post: post)
        self.navigationController?.pushViewController(controller, animated: true)
        pauseVideo()

    }
    
}

extension ShortVideoPostViewController: UITableViewDataSource, UITableViewDelegate, UIScrollViewDelegate  {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel?.currentList.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: ShortVideoPostTableViewCell.self)) as? ShortVideoPostTableViewCell else {
            return UITableViewCell()
        }
    
        if let currentPost = self.viewModel?.currentList.takeSafe(index: indexPath.row) {
            cell.setData(delegate: self, shortVDOPost: currentPost)
        }
        cell.layoutIfNeeded()
        return cell
        
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension

        
    }
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
            if let cell = cell as? ShortVideoPostTableViewCell {
                cell.checkFirstLoad()
                cell.checkMuteState()
                
            }
    }
    
    func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        if let indexPath = tableView.indexPathForRow(at: tableView.bounds.center) {
            if let cell = tableView.cellForRow(at: indexPath) as? ShortVideoPostTableViewCell {
                cell.player?.play()
            }
            if let videoPost = self.viewModel?.currentList.takeSafe(index: indexPath.row) {
                let userID = videoPost.postID
                let userInfo: [AnyHashable: Any] = ["postID": userID]
                NotificationCenter.default.post(
                    name: NSNotification.Name("stopVideo"),
                    object: nil,
                    userInfo: userInfo
                )
            }
        }
    }
    
}


