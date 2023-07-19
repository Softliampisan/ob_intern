//
//  StampLogoVideoViewController.swift
//  ob_intern
//
//  Created by Soft Liampisan on 11/7/2566 BE.
//  Copyright (c) 2566 BE ___ORGANIZATIONNAME___. All rights reserved.

import UIKit
import AVKit
import AVFoundation
import CoreImage.CIFilterBuiltins

class StampLogoVideoViewController: UIViewController {
    
    //MARK: - New Instance
    class func newInstance() -> StampLogoVideoViewController {
        let viewController = StampLogoVideoViewController(nibName: String(describing: StampLogoVideoViewController.self),
                                                          bundle: nil)
        
        let viewModel = StampLogoVideoViewModel(delegate: viewController)
        viewController.viewModel = viewModel
        
        return viewController
    }
    
    //MARK: - IBOutlet
    
    @IBOutlet weak var viewNavigation: UIView!
    @IBOutlet weak var viewButton: UIView!
    @IBOutlet weak var viewVideo: UIView!
    @IBOutlet weak var buttonBack: UIButton!
    @IBOutlet weak var buttonPlay: UIButton!
    @IBOutlet weak var buttonConfirm: UIButton!
    
    //MARK: - Parameters
    private var viewModel: StampLogoVideoViewModel?
    private var addTextView: TextEditDragDropViewController?
    var player: AVPlayer?
    var playerLayer = AVPlayerLayer()
    var videoURL: NSURL?
    var composition = AVMutableVideoComposition()
    var customText: CIImage?
    private var isAssetLoaded = false
    let playerViewController = AVPlayerViewController()

    
    
    //MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupView()
        setupDragAndDrop()
        
    }
    
    //MARK: - Functions
    func setupView() {
        setupVideoPicker()
        buttonPlay.layer.cornerRadius = buttonPlay.frame.width/2
        buttonConfirm.layer.cornerRadius = buttonConfirm.frame.width/2
        viewButton.isHidden = true
        buttonConfirm.isHidden = true
        playerViewController.delegate = self

    }
    
    func setupVideoPicker() {
        let picker = UIImagePickerController()
        picker.delegate = self
        picker.sourceType = .photoLibrary
        picker.delegate = self
        picker.mediaTypes = UIImagePickerController.availableMediaTypes(for: .photoLibrary) ?? []
        picker.mediaTypes = ["public.movie"]
        picker.videoQuality = .typeHigh
        //picker.videoExportPreset = AVAssetExportPresetHEVC1920x1080
        picker.allowsEditing = false
        present(picker, animated: true, completion: nil)
        
    }
    
    func setupDragAndDrop() {
        addTextView = TextEditDragDropViewController.init(nibName: "TextEditDragDropViewController", bundle: nil)
        addTextView?.delegate = self
        if let addTextView = self.addTextView {
            view.addSubview(addTextView.view)
        }
    }
    
    func createVideoPlayer(url: URL) {
        player = AVPlayer(url: url)
        playerLayer = AVPlayerLayer(player: player)
        playerLayer.videoGravity = .resizeAspectFill
        playerLayer.frame = viewVideo.bounds
        viewVideo.layer.addSublayer(playerLayer)
        
    }
    
    func createVideoController(playerItem: AVPlayerItem) {
        player = AVPlayer(playerItem: playerItem)
        print("playerItem \(playerItem)")
        playerViewController.player = player
        self.present(playerViewController, animated: true) {
            self.playerViewController.player!.play()
        }
    }
    
    func addComposition(asset: AVAsset, image: UIImage, url: URL) {
    
        composition = AVMutableVideoComposition(asset: asset) { request in
//            let sourceImage = request.sourceImage.clampedToExtent()
            self.customText = CIImage(image: image)
            
            let positionedText = self.customText?.transformed(by: .init(translationX: 70, y: -60), highQualityDownsample: true)
            
            let backgroundColorFilter = CIFilter(name: "CIConstantColorGenerator")!
            let backgroundColor = CIColor(cgColor: UIColor.red.cgColor) // Replace with your desired background color
            backgroundColorFilter.setValue(backgroundColor, forKey: kCIInputColorKey)
            let background = backgroundColorFilter.outputImage!.cropped(to: request.sourceImage.extent)
            
            //let videoSize = asset.tracks(withMediaType: .video).first?.naturalSize ?? CGSize.zero
            let videoPosition = CGAffineTransform(translationX: (background.extent.width - request.sourceImage.extent.size.width) / 2, y: (background.extent.height - request.sourceImage.extent.size.height) / 2)
            
            //let positionedVideo = request.sourceImage.transformed(by: videoPosition)
            let positionedVideo = request.sourceImage.transformed(by: .init(translationX: (background.extent.width - request.sourceImage.extent.size.width) / 2, y: (background.extent.height - request.sourceImage.extent.size.height) / 2), highQualityDownsample: true)
            //let combinedImage = positionedVideo.composited(over: background)
            let combinedImage = positionedText?.composited(over: positionedVideo.composited(over: background)) ?? request.sourceImage

            
            request.finish(with: combinedImage, context: nil)
        }
        print("render size \(composition.renderSize)")
        composition.renderSize = CGSize(width: 1080, height: 1920)
        
        let exporter = AVAssetExportSession(asset: asset, presetName: AVAssetExportPresetMediumQuality)
        exporter?.outputFileType = .mov
        exporter?.outputURL = url
        print("outputURL \(exporter?.outputURL)")
        exporter?.videoComposition = composition
        exporter?.exportAsynchronously { [weak exporter] in
            guard let export = exporter else {
                return
            }
            
            switch export.status {
            case  .failed:
                print("failed \(exporter?.error)")
                break
            case .cancelled:
                print("cancelled \(exporter?.error)")
                break
            case .completed:
                print("complete")
                let textItem = AVPlayerItem(asset: export.asset)
                textItem.videoComposition = self.composition
                DispatchQueue.main.async { // Execute on main queue
                    self.createVideoController(playerItem: textItem)
                }
            default:
                print("default")
            }
        }
        
    }
    
    
    func createCustomText(url: URL, image: UIImage) {
        
        let asset = AVAsset(url: url)
        addComposition(asset: asset, image: image, url: url)
    
    }
    
    //MARK: - Action
    @IBAction func buttonBackAction(_ sender: Any) {
        player?.pause()
        self.navigationController?.popViewController(animated: true)
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func buttonConfirmAction(_ sender: Any) {
        customText = nil

        if let customText = addTextView?.exportTextImage() {
            createCustomText(url: videoURL! as URL, image: customText)
            
        }
        do { // delete old video
            try FileManager.default.removeItem(at: videoURL! as URL)
        } catch { print(error.localizedDescription) }
        
    }
    
    
    @IBAction func buttonPlayAction(_ sender: Any) {
        guard let player = player else { return }
        if player.isPlaying {
            player.pause()
        } else {
            player.play()
        }
        let buttonImage = player.isPlaying ? "pause" : "play"
        buttonPlay.setButtonImage(imageName: buttonImage, iconColor: .white)
    }
    
}

extension StampLogoVideoViewController: StampLogoVideoViewModelDelegate {
    
    func showError(error: Error) {
        
    }
    
    func showLoading() {
        
    }
    
    func hideLoading() {
        
    }
    
}

extension StampLogoVideoViewController: AVPlayerViewControllerDelegate {

    func playerViewControllerDidFinishDismissal(_ playerViewController: AVPlayerViewController) {
        print("dimissed")
        customText = nil
    }

}

extension StampLogoVideoViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let videoUrl = info[UIImagePickerController.InfoKey.mediaURL] as? NSURL{
            print("videourl: ", videoUrl)
            //trying compression of video
            videoURL = videoUrl
            
            let data = NSData(contentsOf: videoUrl as URL)!
            print("File size before compression: \(Double(data.length / 1048576)) mb")
            createVideoPlayer(url: videoUrl as URL)
            
        }
        else{
            print("Something went wrong in video")
        }
        self.dismiss(animated: true, completion: nil)
    }
    
}

extension StampLogoVideoViewController: TextEditDragDropViewControllerDelegate {
    func onRequestDisplayOnTop() {
        
    }
    
    func onTapClose() {
        buttonConfirm.isHidden = false
        viewButton.isHidden = false
        view.bringSubviewToFront(viewNavigation)
        view.bringSubviewToFront(viewButton)
        
    }
    
    
}

