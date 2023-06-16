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
    var mockImageUrls: [String] = ["https://images.unsplash.com/photo-1609171712489-45b6ba7051a4?ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxzZWFyY2h8M3x8c3Vuc2V0JTIwYWVzdGhldGljfGVufDB8fDB8fHww&auto=format&fit=crop&w=800&q=60",
    "https://plus.unsplash.com/premium_photo-1679599983488-4968d587e00b?ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxzZWFyY2h8MXx8c3Vuc2V0JTIwYWVzdGhldGljfGVufDB8fDB8fHww&auto=format&fit=crop&w=800&q=60", "https://images.unsplash.com/photo-1536098561742-ca998e48cbcc?ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxzZWFyY2h8OXx8c3Vuc2V0JTIwYWVzdGhldGljfGVufDB8fDB8fHww&auto=format&fit=crop&w=800&q=60",
    "https://images.unsplash.com/photo-1609824462369-3d5b0a00fbdb?ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxzZWFyY2h8MTJ8fHN1bnNldCUyMGFlc3RoZXRpY3xlbnwwfHwwfHx8MA%3D%3D&auto=format&fit=crop&w=800&q=60"]
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
        tableView.register(UINib(nibName: "ShortVideoPostTableViewCell", bundle: nil), forCellReuseIdentifier: "ShortVideoPostTableViewCell")
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
        let cell = tableView.dequeueReusableCell(withIdentifier: "ShortVideoPostTableViewCell") as! ShortVideoPostTableViewCell
        cell.setData(caption: caption[indexPath.row], imageURL: mockImageUrls[indexPath.row], hashtag: hashtag[indexPath.row])
        cell.layoutIfNeeded()
        return cell
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension

        
    }
    
    
}

