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
    @IBOutlet weak var viewContainer: UIView!
    @IBOutlet weak var viewTimeline: UIView!
    @IBOutlet weak var viewPannable: UIView!
    @IBOutlet weak var imageViewFrame: UIImageView!
    
    //MARK: - Parameters
    private var WIDTH: CGFloat = 0
    private var HEIGHT: CGFloat = 0
    private let NUM_ITEMS: CGFloat = 8
    private var viewModel: EditShortVideoCoverViewModel?
    private var initialCenter: CGPoint = .zero
    
    //MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupView()
        self.setData()
//        self.calculateWidth()
        collectionView.reloadData()
        viewTimeline.addSubview(viewPannable)
        let panGestureRecognizer = UIPanGestureRecognizer(target: self, action: #selector(didPan(_:)))
        viewPannable.addGestureRecognizer(panGestureRecognizer)
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(didTouch(_:)))
        viewTimeline.addGestureRecognizer(tapGestureRecognizer)
      
    }
    
    override func viewDidAppear(_ animated: Bool) {
        if let cell = self.collectionView.cellForItem(at: IndexPath(index: 0)) as? EditShortVideoCoverCollectionViewCell {
//            if let imageURL = cell.imageViewVideoCover.sd_imageURL {
//                self.imageViewFrame.sd_setImage(with: URL(string: current))
//                self.imageViewVideo.sd_setImage(with: imageURL)
//            }
            if let currentVideo = self.viewModel?.currentList.takeSafe(index: 0) {
                self.imageViewFrame.sd_setImage(with: URL(string: currentVideo.videoImage))
                self.imageViewVideo.sd_setImage(with: URL(string: currentVideo.videoImage))
            }
        }
    }
   
    //MARK: - Functions
    func setupView() {
        imageViewVideo.layer.cornerRadius = 21
        imageViewVideo.clipsToBounds = true
        self.navigationController?.setNavigationBarHidden(true, animated: false)
        collectionView.delegate = self
        collectionView.dataSource = self
        let nibName = String(describing: EditShortVideoCoverCollectionViewCell.self)
        collectionView.register(UINib(nibName: nibName, bundle: nil), forCellWithReuseIdentifier: nibName)
        
        viewPannable.layer.borderColor = UIColor.red.cgColor
        viewPannable.layer.borderWidth = 2.0
        viewPannable.backgroundColor = .clear
        
    }
    
    func setData() {
        imageViewVideo.sd_setImage(with: URL(string: "https://i.pinimg.com/originals/31/9f/f9/319ff939cbca334407451fa12613783e.jpg"))
    }
    
    func calculateWidth() {
        WIDTH = collectionView.bounds.width / NUM_ITEMS
        HEIGHT = collectionView.bounds.height
    }
    
    
    
    //MARK: - Action
    @IBAction func buttonCancelAction(_ sender: Any) {
        self.dismiss(animated: true)
    }
    
    @objc private func didPan(_ sender: UIPanGestureRecognizer) {
        switch sender.state {
        case .began:
            initialCenter = viewPannable.center
          
        case .changed:
            let translation = sender.translation(in: view)
            guard initialCenter.x + translation.x + viewPannable.frame.width < viewContainer.bounds.width && initialCenter.x + translation.x > viewContainer.bounds.minX else { return }
            
            viewPannable.frame = CGRect(x: initialCenter.x + translation.x, y: 0, width: 50, height: 64)
            
            let index = ceil(self.viewPannable.frame.midX/self.WIDTH) - 1
            guard index >= 0 else { return }
            let indexPath = IndexPath(item: Int(index), section: 0)
            if let cell = self.collectionView.cellForItem(at: indexPath) as? EditShortVideoCoverCollectionViewCell {
                if let imageURL = cell.imageViewVideoCover.sd_imageURL {
                    self.imageViewFrame.sd_setImage(with: imageURL)
                    self.imageViewVideo.sd_setImage(with: imageURL)
                }
            }
            
        case .ended,
                .cancelled:
            UIView.animate(withDuration: 0.5, delay: 0.0, usingSpringWithDamping: 0.7, initialSpringVelocity: 0.7, options: [.curveEaseInOut]) {
               
                let index = ceil(self.viewPannable.frame.midX/self.WIDTH) - 1
                guard index >= 0 else { return }
                let indexPath = IndexPath(item: Int(index), section: 0)
                if let cell = self.collectionView.cellForItem(at: indexPath) as? EditShortVideoCoverCollectionViewCell {
                    if let imageURL = cell.imageViewVideoCover.sd_imageURL {
                        self.imageViewFrame.sd_setImage(with: imageURL)
                        self.imageViewVideo.sd_setImage(with: imageURL)
                    }
                }
            }
        default:
            break
        }
    }
    
    @objc private func didTouch(_ sender: UITapGestureRecognizer) {
        
        let location = sender.location(in: view)
        print("touch location \(location)")
        
        initialCenter.x = location.x - 25
        viewPannable.frame = CGRect(x: initialCenter.x , y: 0, width: 50, height: 64)

        let index = ceil(self.viewPannable.frame.midX/self.WIDTH) - 1
        guard index >= 0 else { return }
        let indexPath = IndexPath(item: Int(index), section: 0)
        if let cell = self.collectionView.cellForItem(at: indexPath) as? EditShortVideoCoverCollectionViewCell {
            if let imageURL = cell.imageViewVideoCover.sd_imageURL {
                self.imageViewFrame.sd_setImage(with: imageURL)
                self.imageViewVideo.sd_setImage(with: imageURL)
            }
        }
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


