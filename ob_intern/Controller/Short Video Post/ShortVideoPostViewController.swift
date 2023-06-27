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
    
    //MARK: - Parameters
    private var viewModel: ShortVideoPostViewModel?
    var caption: [String] = ["Lorem ipsum dolor sit amet, consetetur sadipscing elitr, sed diam nonumy eirmod tempor invidunt ut labore et dolore magna aliquyam erat, sed diam voluptua. At vero eos et accusam et justo duo doloreeeeeeeeeeeeeeeee…", "ajdnklanfk kajndskcnkadsnc kjandckjandkjc nakjdcnkajndc naksdjcna  ncaskdjcna", ""]
    var mockImageUrls: [String] = ["https://images3.alphacoders.com/110/1108129.jpg",
                                   "https://wallpaperaccess.com/full/6193236.jpg",
                                   "https://imgix.bustle.com/uploads/image/2022/2/11/c277a32f-c52c-4d7a-98ea-1a0bbec3cf2d-baby-yoda-use-the-force.jpg?w=1200&h=630&fit=crop&crop=focalpoint&fm=jpg&fp-x=0.4813&fp-y=0.3059",
                                   "https://i.pinimg.com/originals/4e/52/2d/4e522df5de3a6903cf2272572eb471aa.jpg"]
    var hashtag: [Bool] = [true, false, true]
    
    
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

    }
    
    //MARK: - Action
    
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
        return caption.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: ShortVideoPostTableViewCell.self)) as? ShortVideoPostTableViewCell else {
            return UITableViewCell()
        }
        
        cell.setData(caption: caption[indexPath.row], imageURL: mockImageUrls[indexPath.row], hashtag: hashtag[indexPath.row])
        cell.layoutIfNeeded()
        return cell
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension

        
    }
    
    
}

