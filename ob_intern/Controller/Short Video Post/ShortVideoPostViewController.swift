//
//  ShortVideoPostViewController.swift
//  ob_intern
//
//  Created by Soft Liampisan on 15/6/2566 BE.
//  Copyright (c) 2566 BE ___ORGANIZATIONNAME___. All rights reserved.

import UIKit

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
    
    //MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupView()
        tableView.reloadData()
    }
    
    
    //MARK: - Functions
    func setupView() {
        tableView.dataSource = self
        tableView.delegate = self
        let nibName = String(describing: ShortVideoPostTableViewCell.self)
        tableView.register(UINib(nibName: nibName, bundle: nil), forCellReuseIdentifier: nibName)
        tableView.estimatedRowHeight = 700
        tableView.rowHeight = UITableView.automaticDimension
        self.navigationController?.setNavigationBarHidden(true, animated: false)
        buttonBack.setButtonImage(imageName: "chevron.left",
                                  iconColor: .black)
        
    }
    
    //MARK: - Action
    @IBAction func buttonBackAction(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)

    }
    
}

extension ShortVideoPostViewController: ShortVideoPostViewModelDelegate {
    
    func showError(error: Error) {
        
    }
    
    func showLoading() {
        
    }
    
    func hideLoading() {
        
    }
    
}

extension ShortVideoPostViewController: UITableViewDataSource, UITableViewDelegate{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel?.currentList.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: ShortVideoPostTableViewCell.self)) as? ShortVideoPostTableViewCell else {
            return UITableViewCell()
        }
    
        if let currentPost = self.viewModel?.currentList.takeSafe(index: indexPath.row) {
            cell.setData(profilePicURL: currentPost.user?.profilePic ?? "",
                         profileName: currentPost.user?.profileName ?? "",
                         caption: currentPost.caption,
                         postImageURL: currentPost.postImage,
                         hashtag: currentPost.hashtag,
                         numLikes: currentPost.numberOfLikes,
                         numComments: currentPost.numberOfComments,
                         datePosted: currentPost.datePosted)
        }
        cell.layoutIfNeeded()
        return cell
        
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension

        
    }
    
    
}

