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
    @IBOutlet weak var progressBar: UIProgressView!
    
    //MARK: - Parameters
    private var viewModel: StampLogoVideoViewModel?
    private var addTextView: TextEditDragDropViewController?
    var player: AVPlayer?
    var playerLayer = AVPlayerLayer()
    var videoURL: NSURL?
    var exporter: AVAssetExportSession?
    var customText: CIImage?
    private var isAssetLoaded = false
    let playerViewController = AVPlayerViewController()
    var exportProgressBarTimer: Timer?

    
    //MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupView()
        setupDragAndDrop()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        progressBar.setProgress(0.0, animated: false)
    }
    
    //MARK: - Functions
    func setupView() {
        setupVideoPicker()
        buttonPlay.layer.cornerRadius = buttonPlay.frame.width/2
        buttonConfirm.layer.cornerRadius = buttonConfirm.frame.width/2
        viewButton.isHidden = true
        buttonConfirm.isHidden = true
        playerViewController.delegate = self
        progressBar.setProgress(0.0, animated: false)

    }

    @objc func updateExportDisplay(_ timer: Timer) {
        guard let progressBar = timer.userInfo as? UIProgressView, let exporter = exporter else { return }

        let progress = exporter.progress
        print("progress \(progress)")
        
        // Update the progress bar on the main queue
        DispatchQueue.main.async {
            progressBar.setProgress(progress, animated: true)
            print("progress in update \(progressBar.progress)")
        }
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
        let width = UIScreen.main.bounds.width
        let height = width * (16/9)
        addTextView?.view.frame = CGRect(x: 0, y: 0, width: width, height: height)
        addTextView?.delegate = self
        if let addTextView = self.addTextView {
            view.addSubview(addTextView.view)
        }
    }
    
    func createVideoPlayer(url: URL) {
        player = AVPlayer(url: url)
        playerLayer = AVPlayerLayer(player: player)
//        playerLayer.videoGravity = .resizeAspectFill
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
        let composition = AVMutableVideoComposition(asset: asset) { request in
            self.customText = CIImage(image: image)
            
            let positionedText = self.customText?.transformed(by: .identity, highQualityDownsample: true)
            
            let backgroundColorFilter = CIFilter(name: "CIConstantColorGenerator")!
            let backgroundColor = CIColor(cgColor: UIColor.black.cgColor)
            backgroundColorFilter.setValue(backgroundColor, forKey: kCIInputColorKey)
            let screenSize = CGRect(x: 0, y: 0, width: 1080, height: 1920)
            let background = backgroundColorFilter.outputImage!.cropped(to: screenSize)
            
            let videoTrack = asset.tracks(withMediaType: .video).first
            let videoSize = videoTrack?.naturalSize ?? CGSize.zero
            let videoAspectRatio = videoSize.width / videoSize.height
            let targetHeight = 1080 / videoAspectRatio
                   
            let videoTransform = request.sourceImage.transformed(by: .init(scaleX: 1080 / videoSize.width, y: targetHeight / videoSize.height))
                        
            let positionedVideo = CGAffineTransform(translationX: 0, y: (background.extent.height - targetHeight) / 2)
            print("positionedText size \(positionedText?.extent.size)")

            let transformedVideo = videoTransform.transformed(by: positionedVideo, highQualityDownsample: true)
            print("y\((background.extent.height - request.sourceImage.extent.size.height)/2)")

            let combinedImage = positionedText?.composited(over: transformedVideo.composited(over: background)) ?? request.sourceImage

            
            request.finish(with: combinedImage, context: nil)
        }
        composition.renderSize = CGSize(width: 1080, height: 1920)
        let outputURL = createOutputURL()

        let exporter = AVAssetExportSession(asset: asset, presetName: AVAssetExportPresetMediumQuality)
        self.exporter = exporter
        exporter?.outputFileType = .mov
        exporter?.outputURL = outputURL
        exporter?.videoComposition = composition
        exportProgressBarTimer = Timer.scheduledTimer(timeInterval: 0.01, target: self, selector: #selector(updateExportDisplay(_:)), userInfo: progressBar, repeats: true)
        

        exporter?.exportAsynchronously { [weak exporter] in
            guard let export = exporter else {
                return
            }
            self.exportProgressBarTimer?.invalidate()
            switch export.status {
            case  .failed:
                print("failed \(export.error)")
                break
            case .cancelled:
                print("cancelled \(export.error)")
                break
            case .completed:
                print("complete")
                let textItem = AVPlayerItem(asset: export.asset)
                textItem.videoComposition = composition
                DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) { [weak self] in  

                    self?.progressBar.setProgress(1.0, animated: true)
//                    let controller = ShortVideoPlayerViewController.newInstance(post: ShortVideoPost.mock(), textItem: textItem)
//                    self?.navigationController?.pushViewController(controller, animated: true)
                    self?.createVideoController(playerItem: textItem)
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
    
    func createOutputURL() -> URL? {
        let randomFilename = UUID().uuidString
        let newFilename = "output_video_\(randomFilename).mov"
        
        guard let documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first else {
            print("Error: Unable to get documents directory.")
            return nil
        }
        
        let outputURL = documentsDirectory.appendingPathComponent(newFilename)
        return outputURL
    }
    
    func removeOldURLs() {
        guard let documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first else {
            print("Error: Unable to get documents directory.")
            return
        }
        
        do {

            let fileURLs = try FileManager.default.contentsOfDirectory(at: documentsDirectory, includingPropertiesForKeys: nil, options: [])
            
            let filteredFileURLs = fileURLs.filter { $0.lastPathComponent.contains("output_video_") }
            
            for fileURL in filteredFileURLs {
                try FileManager.default.removeItem(at: fileURL)
                print("Deleted file: \(fileURL.lastPathComponent)")
            }
        } catch {
            print("Error while accessing or deleting files: \(error)")
        }
        
    }
    
    //MARK: - Action
    @IBAction func buttonBackAction(_ sender: Any) {
        player?.pause()
        progressBar.setProgress(0.0, animated: false)
        self.navigationController?.popViewController(animated: true)
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func buttonConfirmAction(_ sender: Any) {
        removeOldURLs()
        addTextView?.view.clipsToBounds = true
        if let customText = addTextView?.exportTextImage() {
            print("textview width \(addTextView?.view.frame.width)")
            print("textview height \(addTextView?.view.frame.height)")
            print("custom text size \(customText.size)")
            guard let resizedImage = customText.dataWithImageResizeMaxWidthOrHeightValue(value: 1080/3) else { return }
            createCustomText(url: videoURL! as URL, image: resizedImage)
            
        }
        //        do { // delete old video
        //            try FileManager.default.removeItem(at: videoURL! as URL)
        //        } catch { print(error.localizedDescription) }
        
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

