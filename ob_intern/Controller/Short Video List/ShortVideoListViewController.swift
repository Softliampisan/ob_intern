//
//  ShortVideoListViewController.swift
//  ob_intern
//
//  Created by Soft Liampisan on 7/6/2566 BE.
//  Copyright (c) 2566 BE ___ORGANIZATIONNAME___. All rights reserved.

import UIKit
import SDWebImage

class ShortVideoListViewController: UIViewController {
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    private var WIDTH_PER_ROW: CGFloat = 0
    private var HEIGHT_PER_ROW: CGFloat = 0
    private let PADDING: CGFloat = 16
    private let CELL_RATIO: CGFloat = 163/122
    private let ITEM_PER_ROW: Int = 3
    private let INSET: UIEdgeInsets = .init(top: 0, left: 16, bottom: 0, right: 16)
    
    //MARK: - New Instance
    class func newInstance() -> ShortVideoListViewController {
        let viewController = ShortVideoListViewController(nibName: String(describing: ShortVideoListViewController.self),bundle: nil)
        
        let viewModel = ShortVideoListViewModel(delegate: viewController)
        viewController.viewModel = viewModel
        
        return viewController
    }
    
    //MARK: - IBOutlet
    
    //MARK: - Parameters
    private var viewModel: ShortVideoListViewModel?
    
    //MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupView()
        calculateCollectionHeight()
        collectionView.reloadData()
    }
    
    //MARK: - Functions
    func setupView() {
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(UINib(nibName: String(describing: ShortVideoListCollectionViewCell.self), bundle: nil), forCellWithReuseIdentifier: "ShortVideoListCollectionViewCell")
    }
    
    
    private func calculateCollectionHeight() {
        let paddingSpace: CGFloat = (CGFloat(ITEM_PER_ROW) - 1) * PADDING
        let availableWidth = collectionView.frame.size.width - paddingSpace
        WIDTH_PER_ROW = availableWidth / CGFloat(ITEM_PER_ROW)
        HEIGHT_PER_ROW = WIDTH_PER_ROW * CELL_RATIO
        //let heightOfCollection = fandoms.count > 3 ? HEIGHT_PER_ROW * 2 : HEIGHT_PER_ROW
        //self.collectionHeight.constant = heightOfCollection
        
        
    }
    
    //MARK: - Action
    
}

extension ShortVideoListViewController: ShortVideoListViewModelDelegate {
    
    func showError(error: Error) {
        
    }
    
    func showLoading() {
        
    }
    
    func hideLoading() {
        
    }
    
}

extension ShortVideoListViewController: UICollectionViewDataSource, UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel?.currentList.count ?? 0
        
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: String(describing: ShortVideoListCollectionViewCell.self), for: indexPath) as? ShortVideoListCollectionViewCell else {
            return UICollectionViewCell()
        }
        
        if let currentVideo = self.viewModel?.currentList.takeSafe(index: indexPath.row) {
            cell.setData(imageURL: currentVideo.videoImage, label: "\(currentVideo.numViews)")
        }
        
        return cell
    }
    
//    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
//            guard !allMedias.isEmpty else { return }
//            let lastElement = self.allMedias.count - 1
//            if indexPath.row == lastElement {
//                self.interactor?.getMedias(request: .init(refresh: false))
//            }
//    }
    
}

extension ShortVideoListViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 8
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return .zero
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return INSET
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: WIDTH_PER_ROW, height: HEIGHT_PER_ROW)
    }
}


