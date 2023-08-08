//
//  ShortVideoListViewController.swift
//  ob_intern
//
//  Created by Soft Liampisan on 7/6/2566 BE.
//  Copyright (c) 2566 BE ___ORGANIZATIONNAME___. All rights reserved.

import UIKit
import SDWebImage

class ShortVideoListViewController: UIViewController {
    
    deinit {
        print("deinit ShortVideoListViewController")
    }
    //MARK: - New Instance
    class func newInstance(post: ShortVideoPost) -> ShortVideoListViewController {
        let viewController = ShortVideoListViewController(nibName: String(describing: ShortVideoListViewController.self), bundle: nil)
        
        let viewModel = ShortVideoListViewModel(delegate: viewController, post: post)
        viewController.viewModel = viewModel
        
        return viewController
    }
    
    //MARK: - IBOutlet
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var viewEmptyState: UIView!
    @IBOutlet weak var labelProfileName: UILabel!
    @IBOutlet weak var buttonBack: UIButton!
    
    //MARK: - Parameters
    private var WIDTH_PER_ROW: CGFloat = 0
    private var HEIGHT_PER_ROW: CGFloat = 0
    private let PADDING: CGFloat = 16
    private let CELL_RATIO: CGFloat = 163/122
    private let ITEM_PER_ROW: Int = 3
    private var INTERIM_SPACE: CGFloat = 0
    private var INSET: UIEdgeInsets = .init(top: 0, left: 0, bottom: 0, right: 0)
    private var HEADER_HEIGHT: CGFloat = 346
    private var viewModel: ShortVideoListViewModel?
    private var refresher: UIRefreshControl!
    private var activityView = UIActivityIndicatorView(style: .large)

    //MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupView()
        calculateCollectionHeight()
        calculateCellInterimSpacing()
        self.viewModel?.getVideoList()
        collectionView.reloadData()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) { [weak self] in
            self?.setCollectionViewEmptyState()
        }
        if ShortVideoManager.myProfile == true {
            buttonBack.isHidden = true
        }
    }

    
    //MARK: - Functions
    func setupView() {
        self.navigationController?.setNavigationBarHidden(true, animated: false)
        collectionView.delegate = self
        collectionView.dataSource = self
        let nibName = String(describing: ShortVideoListCollectionViewCell.self)
        collectionView.register(UINib(nibName: nibName, bundle: nil), forCellWithReuseIdentifier: nibName)
        let headerNibName = String(describing: ProfileHeaderCollectionReusableView.self)
        collectionView.register(UINib(nibName: headerNibName, bundle: nil), forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: ProfileHeaderCollectionReusableView.identifier)

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
    
    private func calculateCellInterimSpacing() {
        INTERIM_SPACE = floor((UIScreen.main.bounds.width - (WIDTH_PER_ROW * 3))/3)
    }
    
    func setCollectionViewEmptyState(){
//        viewEmptyState.isHidden = !collectionView.visibleCells.isEmpty
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
    
    @objc func loadData() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
            self.viewModel?.getVideoList()
            self.collectionView.reloadData()
            self.refresher.endRefreshing()
        }
    }
    
    //MARK: - Action
    @IBAction func buttonBackAction(_ sender: Any) {
        AppDirector.sharedInstance().rootViewController?.popViewController(animated: true)
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
        self.showActivityIndicator()
    }
    
    func hideLoading() {
        self.hideActivityIndicator()
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
    
//    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
//        guard !(viewModel?.currentList.isEmpty ?? false) else { return }
//        let lastElement = (self.viewModel?.currentList.count ?? 0) - 1
//            if indexPath.row == lastElement {
//                viewModel?.addMockData()
//                collectionView.reloadData()
//            }
//    }
 
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let profileHeader = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: ProfileHeaderCollectionReusableView.identifier, for: indexPath) as! ProfileHeaderCollectionReusableView
        profileHeader.setData(imageURLProfilePic: viewModel?.post?.user?.profilePic ?? "",
                              imageURLFrontCover: viewModel?.post?.media?.coverImage ?? "",
                              label: viewModel?.post?.user?.profileName ?? "")
        labelProfileName.text = viewModel?.post?.user?.profileName
        profileHeader.delegate = self
        profileHeader.hideSettings()
        return profileHeader
    }
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return CGSize(width: UIScreen.main.bounds.width, height: HEADER_HEIGHT)
    }
    
}

extension ShortVideoListViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 8
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 5
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        INSET = .init(top: 0, left: INTERIM_SPACE, bottom: 0, right: INTERIM_SPACE)
        return INSET
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: WIDTH_PER_ROW, height: HEIGHT_PER_ROW)
    }
}

extension ShortVideoListViewController: ProfileHeaderCollectionReusableViewDelegate {
    func didTapSettingsButton() {
        let settingsViewController = SettingsViewController()
        settingsViewController.modalPresentationStyle = .fullScreen
        self.present(settingsViewController, animated: true)
    }
    
    
}

