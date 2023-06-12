//
//  EditVideoTimelineViewController.swift
//  ob_intern
//
//  Created by Soft Liampisan on 9/6/2566 BE.
//  Copyright (c) 2566 BE ___ORGANIZATIONNAME___. All rights reserved.

import UIKit
import SDWebImage

class EditShortVideoCoverViewController: UIViewController {

    //MARK: - New Instance
    class func newInstance() -> EditShortVideoCoverViewController {
        let viewController = EditShortVideoCoverViewController(nibName: String(describing: EditShortVideoCoverViewController.self),
                                                       bundle: nil)
        
        let viewModel = EditShortVideoCoverViewModel(delegate: viewController)
        viewController.viewModel = viewModel
        
        return viewController
    }
    
    //MARK: - IBOutlet
    @IBOutlet weak var buttonCancel: UIButton!
    @IBOutlet weak var buttonAgree: UIButton!
    @IBOutlet weak var labelSelectCover: UILabel!
    @IBOutlet weak var imageViewVideo: UIImageView!
    @IBOutlet weak var collectionView: UICollectionView!
    
    //MARK: - Parameters
    private var WIDTH: CGFloat = 0
    private var HEIGHT: CGFloat = 0
    private let NUM_ITEMS: CGFloat = 8
    private var viewModel: EditShortVideoCoverViewModel?
    
    //MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupView()
        collectionView.reloadData()

    }
    
    //MARK: - Functions
    func setupView() {
        imageViewVideo.layer.cornerRadius = 21
        imageViewVideo.clipsToBounds = true
        imageViewVideo.sd_setImage(with: URL(string: "https://i.pinimg.com/originals/31/9f/f9/319ff939cbca334407451fa12613783e.jpg"))
        self.navigationController?.setNavigationBarHidden(true, animated: false)
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(UINib(nibName: String(describing: EditShortVideoCoverCollectionViewCell.self), bundle: nil), forCellWithReuseIdentifier: "EditShortVideoCoverCollectionViewCell")

    }
    
    //MARK: - Action
    @IBAction func buttonCancelAction(_ sender: Any) {
        self.dismiss(animated: true)
    }
    
}

extension EditShortVideoCoverViewController: EditShortVideoCoverViewModelDelegate {
    
    func showError(error: Error) {
        
    }
    
    func showLoading() {
        
    }
    
    func hideLoading() {
        
    }
    
}

extension EditShortVideoCoverViewController: UICollectionViewDataSource, UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel?.currentList.count ?? 0
        
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: String(describing: EditShortVideoCoverCollectionViewCell.self), for: indexPath) as? EditShortVideoCoverCollectionViewCell else {
            return UICollectionViewCell()
        }
        
        if let currentVideo = self.viewModel?.currentList.takeSafe(index: indexPath.row) {
            cell.setData(imageURL: currentVideo.videoImage)
        }
        
        return cell
    }
    
}

extension EditShortVideoCoverViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        WIDTH = collectionView.bounds.width / NUM_ITEMS
        HEIGHT = collectionView.bounds.height
        return CGSize(width: WIDTH, height: HEIGHT)
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return .zero
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0.0
    }
}

