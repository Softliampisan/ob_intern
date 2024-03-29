//
//  EditVideoTimelineViewController.swift
//  ob_intern
//
//  Created by Soft Liampisan on 9/6/2566 BE.
//  Copyright (c) 2566 BE ___ORGANIZATIONNAME___. All rights reserved.

import UIKit
import SDWebImage
import AVFoundation

protocol EditShortVideoCoverViewControllerDelegate: AnyObject {
    func didSelectFrontCover(image: UIImage)
}

class EditShortVideoCoverViewController: UIViewController {
    
    //MARK: - New Instance
    class func newInstance(delegate: EditShortVideoCoverViewControllerDelegate, asset: AVAsset? = nil) -> EditShortVideoCoverViewController {
        let viewController = EditShortVideoCoverViewController(nibName: String(describing: EditShortVideoCoverViewController.self),
                                                               bundle: nil)
        
        let viewModel = EditShortVideoCoverViewModel(delegate: viewController, asset: asset)
        viewController.viewModel = viewModel
        viewController.delegate = delegate
        return viewController
    }
    
    //MARK: - IBOutlet
    @IBOutlet weak var buttonCancel: UIButton!
    @IBOutlet weak var buttonAgree: UIButton!
    @IBOutlet weak var labelSelectCover: UILabel!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var viewContainer: UIView!
    @IBOutlet weak var viewTimeline: UIView!
    @IBOutlet weak var viewPannable: UIView!
    @IBOutlet weak var imageViewVideo: UIImageView!
    @IBOutlet weak var imageViewFrame: UIImageView!
    
    //MARK: - Parameters
    private var WIDTH: CGFloat = 0
    private var HEIGHT: CGFloat = 0
    private let NUM_ITEMS: CGFloat = 8
    private var viewModel: EditShortVideoCoverViewModel?
    private var initialCenter: CGPoint = .zero
    weak var delegate: EditShortVideoCoverViewControllerDelegate?
    
    //MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupView()
        self.setData()
        collectionView.reloadData()
        viewTimeline.addSubview(viewPannable)
        let panGestureRecognizer = UIPanGestureRecognizer(target: self, action: #selector(didPan(_:)))
        viewPannable.addGestureRecognizer(panGestureRecognizer)
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(didTouch(_:)))
        viewTimeline.addGestureRecognizer(tapGestureRecognizer)
      
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
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
        self.setFirstFrame()
    }
    
    func setFirstFrame() {
        viewModel?.generateFramesFromAsset(numberOfFrames: 8)
        self.imageViewVideo.image = self.viewModel?.videoFrames[0]
        self.imageViewFrame.image = self.viewModel?.videoFrames[0]
        
    }
    
    func calculateWidth() {
        WIDTH = collectionView.bounds.width / NUM_ITEMS
        HEIGHT = collectionView.bounds.height
    }
    
    func setupFrame(){
        let index = ceil(self.viewPannable.frame.midX/self.WIDTH) - 1
        guard index >= 0 else { return }
        let indexPath = IndexPath(item: Int(index), section: 0)
        
        guard let cell = self.collectionView.cellForItem(at: indexPath) as? EditShortVideoCoverCollectionViewCell, let videoFrame = cell.imageViewVideoCover.image else { return }

        self.imageViewFrame.image = videoFrame
        self.imageViewVideo.image = videoFrame
        
    }
    
    //MARK: - Action
    @IBAction func buttonCancelAction(_ sender: Any) {
        AppDirector.sharedInstance().rootViewController?.popViewController(animated: true)
    }
    
    
    @IBAction func buttonConfirmAction(_ sender: Any) {
        guard let frontCover = imageViewVideo.image else { return }
        delegate?.didSelectFrontCover(image: frontCover)
        AppDirector.sharedInstance().rootViewController?.popViewController(animated: true)
    }
    
    @objc private func didPan(_ sender: UIPanGestureRecognizer) {
        switch sender.state {
        case .began:
            initialCenter = viewPannable.center
        case .changed:
            let translation = sender.translation(in: view)
            guard initialCenter.x + translation.x + viewPannable.frame.width < viewContainer.bounds.width && initialCenter.x + translation.x > viewContainer.bounds.minX else { return }
            
            viewPannable.frame = CGRect(x: initialCenter.x + translation.x, y: 0, width: 50, height: HEIGHT)
            self.setupFrame()
            
        case .ended,
                .cancelled:
            UIView.animate(withDuration: 0.5, delay: 0.0, usingSpringWithDamping: 0.7, initialSpringVelocity: 0.7, options: [.curveEaseInOut]) {
                self.setupFrame()

            }
        default:
            break
        }
    }
    
    @objc private func didTouch(_ sender: UITapGestureRecognizer) {
        
        let location = sender.location(in: view)
        
        initialCenter.x = location.x - (WIDTH/2)
        if initialCenter.x < viewContainer.bounds.minX {
            initialCenter.x = viewContainer.bounds.minX
        }
        if initialCenter.x > viewContainer.bounds.maxX - WIDTH {
            initialCenter.x = viewContainer.bounds.maxX - WIDTH
        }
        
        viewPannable.frame = CGRect(x: initialCenter.x, y: 0, width: 50, height: HEIGHT)

        self.setupFrame()
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
        return viewModel?.videoFrames.count ?? 0
        
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: String(describing: EditShortVideoCoverCollectionViewCell.self), for: indexPath) as? EditShortVideoCoverCollectionViewCell else {
            return UICollectionViewCell()
        }
        
        if let videoFrames = self.viewModel?.videoFrames.takeSafe(index: indexPath.row) {
            cell.setData(image: videoFrames)
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


