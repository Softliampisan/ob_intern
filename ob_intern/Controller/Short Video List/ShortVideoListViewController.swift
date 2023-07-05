//
//  ShortVideoListViewController.swift
//  ob_intern
//
//  Created by Soft Liampisan on 7/6/2566 BE.
//  Copyright (c) 2566 BE ___ORGANIZATIONNAME___. All rights reserved.

import UIKit
import SDWebImage

class ShortVideoListViewController: UIViewController {
    
    //MARK: - New Instance
    class func newInstance() -> ShortVideoListViewController {
        let viewController = ShortVideoListViewController(nibName: String(describing: ShortVideoListViewController.self), bundle: nil)
        
        let viewModel = ShortVideoListViewModel(delegate: viewController)
        viewController.viewModel = viewModel
        
        return viewController
    }
    
    //MARK: - IBOutlet
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var viewEmptyState: UIView!
    @IBOutlet weak var buttonBack: UIButton!
    
    //MARK: - Parameters
    private var WIDTH_PER_ROW: CGFloat = 0
    private var HEIGHT_PER_ROW: CGFloat = 0
    private let PADDING: CGFloat = 16
    private let CELL_RATIO: CGFloat = 163/122
    private let ITEM_PER_ROW: Int = 3
    private let INSET: UIEdgeInsets = .init(top: 0, left: 16, bottom: 0, right: 16)
    private var viewModel: ShortVideoListViewModel?
    private var refresher: UIRefreshControl!

    //MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupView()
        calculateCollectionHeight()
        self.viewModel?.getVideoList()
        collectionView.reloadData()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) { [weak self] in 
            self?.setCollectionViewEmptyState()
        }
    }
    
    //MARK: - Functions
    func setupView() {
        self.navigationController?.setNavigationBarHidden(true, animated: false)
        collectionView.delegate = self
        collectionView.dataSource = self
        let nibName = String(describing: ShortVideoListCollectionViewCell.self)
        collectionView.register(UINib(nibName: nibName, bundle: nil), forCellWithReuseIdentifier: nibName)
        refresher = UIRefreshControl()
        collectionView.alwaysBounceVertical = true
        refresher.tintColor = UIColor.red
        refresher.addTarget(self, action: #selector(loadData), for: .valueChanged)
        collectionView.addSubview(refresher)
        viewEmptyState.isHidden = true
    }
    
    
    private func calculateCollectionHeight() {
        let paddingSpace: CGFloat = (CGFloat(ITEM_PER_ROW) - 1) * PADDING
        let availableWidth = collectionView.frame.size.width - paddingSpace
        WIDTH_PER_ROW = availableWidth / CGFloat(ITEM_PER_ROW)
        HEIGHT_PER_ROW = WIDTH_PER_ROW * CELL_RATIO
        
    }
    
    func setCollectionViewEmptyState(){
        viewEmptyState.isHidden = !collectionView.visibleCells.isEmpty
    }
    
    @objc func loadData() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
            self.viewModel?.updateData()
            self.collectionView.reloadData()
            self.refresher.endRefreshing()
        }
    }
    
    //MARK: - Action
    @IBAction func buttonBackAction(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)

    }
    
}

extension ShortVideoListViewController: ShortVideoListViewModelDelegate {
    func showAlert(alert: UIAlertController) {
        self.present(alert, animated: true, completion: nil)
    }
    
    func updateData() {
        collectionView.reloadData()
    }
    
    
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
            cell.setData(imageURL: currentVideo.media?.coverImage ?? "",
                         label: "\(currentVideo.numberOfViews)")
        }
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        guard !(viewModel?.currentList.isEmpty ?? false) else { return }
        let lastElement = (self.viewModel?.currentList.count ?? 0) - 1
            if indexPath.row == lastElement {
                viewModel?.addMockData()
                collectionView.reloadData()
            }
    }
    
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


