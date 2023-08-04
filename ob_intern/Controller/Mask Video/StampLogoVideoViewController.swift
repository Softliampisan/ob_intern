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
import Photos

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
    private var isAssetLoaded = false
    private var WIDTH_CONFIG: CGFloat = 1080
    private var HEIGHT_CONFIG: CGFloat = 1920
    var player: AVPlayer?
    var playerLayer = AVPlayerLayer()
    var videoURL: NSURL?
    var exporter: AVAssetExportSession?
    var customText: CIImage?
    var exportProgressBarTimer: Timer?
    let playerViewController = AVPlayerViewController()
    
    
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
        showPickerAlert()
        buttonPlay.layer.cornerRadius = buttonPlay.frame.width/2
        buttonConfirm.layer.cornerRadius = buttonConfirm.frame.width/2
        viewButton.isHidden = true
        buttonConfirm.isHidden = true
        progressBar.setProgress(0.0, animated: false)
        
    }
    
    @objc func updateExportDisplay(_ timer: Timer) {
        guard let progressBar = timer.userInfo as? UIProgressView, let progress = exporter?.progress else { return }
        
        print("progress \(progress)")
        
        // Update the progress bar on the main queue
        DispatchQueue.main.async {
            progressBar.setProgress(progress, animated: true)
            print("progress in update \(progressBar.progress)")
        }
    }
    
    func checkAuthorizationStatus(photoStatus: PHAuthorizationStatus? = nil, cameraStatus: AVAuthorizationStatus? = nil, alertMessage: String) {
     
        if (photoStatus != nil && photoStatus == PHAuthorizationStatus.denied || cameraStatus != nil && cameraStatus == AVAuthorizationStatus.denied) {
            let alertController = UIAlertController (title: alertMessage, message: nil, preferredStyle: .alert)
            let settingsAction = UIAlertAction(title: "Settings", style: .default) { (_) -> Void in
                
                guard let settingsUrl = URL(string: UIApplication.openSettingsURLString) else { return }
                if UIApplication.shared.canOpenURL(settingsUrl) {
                    UIApplication.shared.open(settingsUrl, completionHandler: { (success) in
                        print("Settings opened: \(success)")
                    })
                }
            }
            alertController.addAction(settingsAction)
            let cancelAction = UIAlertAction(title: "Cancel", style: .default, handler: nil)
            alertController.addAction(cancelAction)
            present(alertController, animated: true, completion: nil)
        }
    }
    
    
    func showPickerAlert() {
        let alertController = UIAlertController(title: "Choose an option", message: nil, preferredStyle: .alert)
        
        let cameraAction = UIAlertAction(title: "Open Video Camera", style: .default) { [weak self] _ in
            self?.openVideoCamera()
        }
        alertController.addAction(cameraAction)
        
        let libraryAction = UIAlertAction(title: "Add Video", style: .default) { [weak self] _ in
            self?.addVideo()
        }
        alertController.addAction(libraryAction)
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .default) { _ in
            AppDirector.sharedInstance().rootViewController?.popToRootViewController(animated: true)
        }
        alertController.addAction(cancelAction)
        
        present(alertController, animated: true, completion: nil)
    }
    
    func openVideoCamera() {
        checkAuthorizationStatus(cameraStatus: AVCaptureDevice.authorizationStatus(for: .video), alertMessage: "Please go to settings for access to camera")
        checkAuthorizationStatus(cameraStatus: AVCaptureDevice.authorizationStatus(for: .audio), alertMessage: "Please go to settings for access to microphone")
        openImagePicker(sourceType: .camera, mediaType: ["public.movie"], isAllowsEditing: false, cameraCaptureMode: .video)
    }
    
    func addVideo() {
        checkAuthorizationStatus(photoStatus: PHPhotoLibrary.authorizationStatus(), alertMessage: "Please go to settings for access to photo library")
        openImagePicker(sourceType: .photoLibrary, mediaType: ["public.movie"], isAllowsEditing: false)
    }
    
    func openImagePicker(sourceType: UIImagePickerController.SourceType,
                         mediaType: [String],
                         isAllowsEditing: Bool,
                         cameraCaptureMode: UIImagePickerController.CameraCaptureMode? = nil) {
        let picker = UIImagePickerController()
        picker.delegate = self
        picker.sourceType = sourceType
        picker.videoMaximumDuration = 10
        picker.allowsEditing = isAllowsEditing
        picker.mediaTypes = mediaType
        if let mode = cameraCaptureMode {
            picker.cameraCaptureMode = mode
        }
        picker.videoQuality = .typeHigh
        present(picker, animated: true, completion: nil)
    }
    
    func setupDragAndDrop() {
        addTextView = TextEditDragDropViewController.init(nibName: String(describing: TextEditDragDropViewController.self), bundle: nil)
        let width = self.view.frame.width
        let height = self.view.frame.height
        addTextView?.view.frame = CGRect(x: 0, y: 0, width: width, height: height)
        addTextView?.view.layoutIfNeeded()
        addTextView?.delegate = self
        if let addTextView = self.addTextView {
            view.addSubview(addTextView.view)
        }
        self.view.layoutIfNeeded()
    }
    
    func createVideoPlayer(url: URL) {
        player = AVPlayer(url: url)
        playerLayer = AVPlayerLayer(player: player)
        playerLayer.frame = viewVideo.bounds
        viewVideo.layer.addSublayer(playerLayer)
        
    }
    
    func addComposition(asset: AVAsset, image: UIImage, url: URL) {
        let composition = AVMutableVideoComposition(asset: asset) { [weak self] request in
            guard let self = self else { return }
            self.customText = CIImage(image: image)
            
            let positionedText = self.customText?.transformed(by: .identity, highQualityDownsample: true)
            
            //background
            let backgroundColorFilter = CIFilter(name: "CIConstantColorGenerator")!
            let backgroundColor = CIColor(cgColor: UIColor.black.cgColor)
            backgroundColorFilter.setValue(backgroundColor, forKey: kCIInputColorKey)
            let screenSize = CGRect(x: 0, y: 0, width: WIDTH_CONFIG, height: HEIGHT_CONFIG)
            let background = backgroundColorFilter.outputImage!.cropped(to: screenSize)
            
            //calculate video size
            let videoTrack = asset.tracks(withMediaType: .video).first
//            let instruction = videoCompositionInstruction(videoTrack as! AVCompositionTrack, asset: asset)
//            composition.instructions = [instruction]

            let videoSize = videoTrack?.naturalSize ?? CGSize.zero
            let videoAspectRatio = videoSize.width / videoSize.height
            let targetHeight = WIDTH_CONFIG / videoAspectRatio
            
            //check video orientation
            let firstAssetInfo = orientationFromTransform(videoTrack!.preferredTransform)
            let firstLayerInstruction = AVMutableVideoCompositionLayerInstruction(assetTrack: videoTrack!)
            
            if firstAssetInfo.isPortrait {

                let rotate = __CGAffineTransformMake(0.0, 1.0, -1.0, 0.0, 0.0, 0.0)
                let scale = CGAffineTransform(scaleX: WIDTH_CONFIG / videoSize.width, y: targetHeight / videoSize.height)
                let move = CGAffineTransform(translationX: 0, y: (background.extent.height - targetHeight) / 2)
                let transform = rotate.concatenating(scale).concatenating(move)
                firstLayerInstruction.setTransform(transform, at: .zero)

            } else {

                let scale = CGAffineTransform(scaleX: WIDTH_CONFIG / videoSize.width, y: targetHeight / videoSize.height)
                let move = CGAffineTransform(translationX: 0, y: (background.extent.height - targetHeight) / 2)
                let transform = scale.concatenating(move)
                firstLayerInstruction.setTransform(transform, at: .zero)
            }

            //resize video
            print("video width \(videoSize.width)")
            print("video height \(videoSize.height)")
                        
            let videoTransform = request.sourceImage.transformed(by: .init(scaleX: WIDTH_CONFIG / videoSize.width, y: targetHeight / videoSize.height))
            print("video transform size \(videoTransform)")

            //set video position
            let positionedVideo = CGAffineTransform(translationX: 0, y: (background.extent.height - targetHeight) / 2)
            
            //combine resize video and video position
            let transformedVideo = videoTransform.transformed(by: positionedVideo, highQualityDownsample: true)
            print("y\((background.extent.height - request.sourceImage.extent.size.height)/2)")
            
            //combine text and video over background
            let combinedImage = positionedText?.composited(over: transformedVideo.composited(over: background)) ?? request.sourceImage
            request.finish(with: combinedImage, context: nil)
        }
        composition.renderSize = CGSize(width: WIDTH_CONFIG, height: HEIGHT_CONFIG)

        let outputURL = createOutputURL()
        
        //export video
        let exporter = AVAssetExportSession(asset: asset, presetName: AVAssetExportPresetMediumQuality)
        guard let exporter = exporter else { return }
        self.exporter = exporter
        exporter.outputFileType = .mov
        exporter.outputURL = outputURL
        exporter.videoComposition = composition
        exportProgressBarTimer = Timer.scheduledTimer(timeInterval: 0.01, target: self, selector: #selector(updateExportDisplay), userInfo: progressBar, repeats: true)
        
        exporter.exportAsynchronously { [weak exporter] in
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
                DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) { [weak self] in
                    self?.progressBar.setProgress(1.0, animated: true)
                    
                    if let url = outputURL {
                        let outputAsset = AVURLAsset(url: url)
                        AppDirector.sharedInstance().displayCreateShortViewController(asset: outputAsset)

                    }
                }
            default:
                print("default")
            }
        }
        
    }
    
    func orientationFromTransform(_ transform: CGAffineTransform) -> (orientation: UIImage.Orientation, isPortrait: Bool) {
        var assetOrientation = UIImage.Orientation.up
        var isPortrait = false
        let tfA = transform.a
        let tfB = transform.b
        let tfC = transform.c
        let tfD = transform.d
        
        if tfA == 0 && tfB == 1.0 && tfC == -1.0 && tfD == 0 {
            assetOrientation = .right
            isPortrait = true
        } else if tfA == 0 && tfB == -1.0 && tfC == 1.0 && tfD == 0 {
            assetOrientation = .left
            isPortrait = true
        } else if tfA == 1.0 && tfB == 0 && tfC == 0 && tfD == 1.0 {
            assetOrientation = .up
        } else if tfA == -1.0 && tfB == 0 && tfC == 0 && tfD == -1.0 {
            assetOrientation = .down
        }
        return (assetOrientation, isPortrait)
    }
    
//    static func videoCompositionInstruction(_ track: AVCompositionTrack, asset: AVAsset) -> AVMutableVideoCompositionLayerInstruction {
//        // 1
//        let instruction = AVMutableVideoCompositionLayerInstruction(assetTrack: track)
//
//        // 2
//        let assetTrack = asset.tracks(withMediaType: .video)[0]
//
//        // 3
//        let transform = assetTrack.preferredTransform
//        let assetInfo = orientationFromTransform(transform)
//
//        var scaleToFitRatio = UIScreen.main.bounds.width / assetTrack.naturalSize.width
//        if assetInfo.isPortrait {
//            // 4
//            scaleToFitRatio = UIScreen.main.bounds.width / assetTrack.naturalSize.height
//            let scaleFactor = CGAffineTransform(scaleX: scaleToFitRatio, y: scaleToFitRatio)
//            instruction.setTransform(assetTrack.preferredTransform.concatenating(scaleFactor), at: .zero)
//        } else {
//            // 5
//            let scaleFactor = CGAffineTransform(scaleX: scaleToFitRatio, y: scaleToFitRatio)
//            var concat = assetTrack.preferredTransform.concatenating(scaleFactor).concatenating(CGAffineTransform(translationX: 0, y: UIScreen.main.bounds.width / 2))
//            if assetInfo.orientation == .down {
//                let fixUpsideDown = CGAffineTransform(rotationAngle: CGFloat(Double.pi))
//                let windowBounds = UIScreen.main.bounds
//                let yFix = assetTrack.naturalSize.height + windowBounds.height
//                let centerFix = CGAffineTransform(translationX: assetTrack.naturalSize.width, y: yFix)
//                concat = fixUpsideDown.concatenating(centerFix).concatenating(scaleFactor)
//            }
//            instruction.setTransform(concat, at: .zero)
//        }
//
//        return instruction
//    }
    
    func createCustomText(url: URL, image: UIImage) {
        let asset = AVAsset(url: url)
        let composition = AVMutableComposition()
        guard let videoTrack = asset.tracks(withMediaType: .video).first else { return }
        guard let audioTrack = asset.tracks(withMediaType: .audio).first else { return }
        
        //combine video and audio track
        let compositionCommentaryTrack: AVMutableCompositionTrack? = composition.addMutableTrack(withMediaType: AVMediaType.audio, preferredTrackID: kCMPersistentTrackID_Invalid)
        let compositionVideoTrack: AVMutableCompositionTrack? = composition.addMutableTrack(withMediaType: AVMediaType.video, preferredTrackID: kCMPersistentTrackID_Invalid)
        try? compositionCommentaryTrack?.insertTimeRange(CMTimeRangeMake(start: CMTime.zero, duration: asset.duration), of: audioTrack, at: CMTime.zero)
        try? compositionVideoTrack?.insertTimeRange(CMTimeRangeMake(start: CMTime.zero, duration: asset.duration), of: videoTrack, at: CMTime.zero)
        
        addComposition(asset: composition, image: image, url: url)
        
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
        AppDirector.sharedInstance().rootViewController?.popViewController(animated: true)
    }
    
    @IBAction func buttonConfirmAction(_ sender: Any) {
        removeOldURLs()
        addTextView?.view.clipsToBounds = true
        if let customText = addTextView?.exportTextImage() {
            guard let resizedImage = customText.dataWithImageResizeMaxWidthOrHeightValue(value: WIDTH_CONFIG/UIScreen.main.scale) else { return }
            createCustomText(url: videoURL! as URL, image: resizedImage)
            
        }
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

extension StampLogoVideoViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let videoUrl = info[UIImagePickerController.InfoKey.mediaURL] as? NSURL{
            print("videourl: ", videoUrl)
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

