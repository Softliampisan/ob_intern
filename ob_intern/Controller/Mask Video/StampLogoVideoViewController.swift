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
    
    func test(currentAsset: AVAsset, videoCompositionSoft: AVMutableVideoComposition) {
        let composition = AVMutableComposition.init()
        
        let videoComposition = AVMutableVideoComposition()
        videoComposition.frameDuration = CMTimeMake(value: 1, timescale: 30)
        videoComposition.renderScale  = 1.0
        
        let compositionCommentaryTrack: AVMutableCompositionTrack? = composition.addMutableTrack(withMediaType: AVMediaType.audio, preferredTrackID: kCMPersistentTrackID_Invalid)
        
        
        let compositionVideoTrack: AVMutableCompositionTrack? = composition.addMutableTrack(withMediaType: AVMediaType.video, preferredTrackID: kCMPersistentTrackID_Invalid)
        
        
        let clipVideoTrack:AVAssetTrack = currentAsset.tracks(withMediaType: AVMediaType.video)[0]
        
        let audioTrack: AVAssetTrack? = currentAsset.tracks(withMediaType: AVMediaType.audio)[0]
        
        try? compositionCommentaryTrack?.insertTimeRange(CMTimeRangeMake(start: CMTime.zero, duration: currentAsset.duration), of: audioTrack!, at: CMTime.zero)
        
        try? compositionVideoTrack?.insertTimeRange(CMTimeRangeMake(start: CMTime.zero, duration: currentAsset.duration), of: clipVideoTrack, at: CMTime.zero)
//
//        let orientation = VideoModel.videoOrientation(currentAsset)
//        var isPortrait = false
//
//        switch orientation {
//        case .landscapeRight:
//            isPortrait = false
//        case .landscapeLeft:
//            isPortrait = false
//        case .portrait:
//            isPortrait = true
//        case .portraitUpsideDown:
//            isPortrait = true
//        }
//
        var naturalSize = clipVideoTrack.naturalSize
        
//        if isPortrait
//        {
//            naturalSize = CGSize.init(width: naturalSize.height, height: naturalSize.width)
//        }
        
        videoCompositionSoft.renderSize = naturalSize
        
        let scale = CGFloat(1.0)
        
        var transform = CGAffineTransform.init(scaleX: CGFloat(scale), y: CGFloat(scale))
        
//        switch orientation {
//        case .landscapeRight: break
//            // isPortrait = false
//        case .landscapeLeft:
//            transform = transform.translatedBy(x: naturalSize.width, y: naturalSize.height)
//            transform = transform.rotated(by: .pi)
//        case .portrait:
//            transform = transform.translatedBy(x: naturalSize.width, y: 0)
//            transform = transform.rotated(by: CGFloat(M_PI_2))
//        case .portraitUpsideDown:break
//        }
        
        let frontLayerInstruction = AVMutableVideoCompositionLayerInstruction(assetTrack: compositionVideoTrack!)
        frontLayerInstruction.setTransform(transform, at: CMTime.zero)
        
        let MainInstruction = AVMutableVideoCompositionInstruction()
        MainInstruction.timeRange = CMTimeRangeMake(start: CMTime.zero, duration: composition.duration)
        MainInstruction.layerInstructions = [frontLayerInstruction]
        videoComposition.instructions = [MainInstruction]
        
        let parentLayer = CALayer.init()
        parentLayer.frame = CGRect.init(x: 0, y: 0, width: naturalSize.width, height: naturalSize.height)
        
        let videoLayer = CALayer.init()
        videoLayer.frame = parentLayer.frame
        
        
        let layer = CATextLayer()
        layer.string = "HELLO ALL"
        layer.foregroundColor = UIColor.white.cgColor
        layer.backgroundColor = UIColor.orange.cgColor
        layer.fontSize = 32
        layer.frame = CGRect.init(x: 0, y: 0, width: 300, height: 100)
        
        var rct = layer.frame;
        
        let widthScale = self.viewVideo.frame.size.width/naturalSize.width
        
        rct.size.width /= widthScale
        rct.size.height /= widthScale
        rct.origin.x /= widthScale
        rct.origin.y /= widthScale
        
        
        
        parentLayer.addSublayer(videoLayer)
        parentLayer.addSublayer(layer)
        
        videoComposition.animationTool = AVVideoCompositionCoreAnimationTool.init(postProcessingAsVideoLayer: videoLayer, in: parentLayer)
        
        let documentsPath = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0]
        let videoPath = documentsPath+"/cropEditVideo.mov"
        
        let fileManager = FileManager.default
        
        if fileManager.fileExists(atPath: videoPath)
        {
            try! fileManager.removeItem(atPath: videoPath)
        }
        
        print("video path \(videoPath)")
        
        var exportSession = AVAssetExportSession.init(asset: composition, presetName: AVAssetExportPresetHighestQuality)
        exportSession?.outputFileType = AVFileType.mov
        exportSession?.outputURL = URL.init(fileURLWithPath: videoPath)
        exportSession?.videoComposition = videoCompositionSoft
        var exportProgress: Float = 0
        let queue = DispatchQueue(label: "Export Progress Queue")
        queue.async(execute: {() -> Void in
            while exportSession != nil {
                //                int prevProgress = exportProgress;
                exportProgress = (exportSession?.progress)!
                print("current progress == \(exportProgress)")
                sleep(1)
            }
        })
        
        exportSession?.exportAsynchronously(completionHandler: {
            
            
            if exportSession?.status == AVAssetExportSession.Status.failed
            {
                print("Failed \(exportSession?.error)")
            }else if exportSession?.status == AVAssetExportSession.Status.completed
            {
                exportSession = nil
                
                let asset = AVAsset.init(url: URL.init(fileURLWithPath: videoPath))
                DispatchQueue.main.async {
                    let item = AVPlayerItem.init(asset: asset)
                    
                    let textItem = AVPlayerItem(asset: asset)
//                                    textItem.videoComposition = export.videoComposition
                                    DispatchQueue.main.async { // Execute on main queue
                                        self.createVideoController(playerItem: textItem)
                                    }
                    
//                    self.player?.replaceCurrentItem(with: item)
//
//                    let assetDuration = CMTimeGetSeconds(composition.duration)
//                    self.progressSlider.maximumValue = Float(assetDuration)
                    
//                    self.syncLayer.removeFromSuperlayer()
//                    self.lblIntro.isHidden = true
                    
//                    self.player.play()
                    //                    let url =  URL.init(fileURLWithPath: videoPath)
                    //                    let activityVC = UIActivityViewController(activityItems: [url], applicationActivities: [])
                    //                    self.present(activityVC, animated: true, completion: nil)
                }
                
            }
        })
       
    }
    
    //    func ConvertAvcompositionToAvasset(avComp: AVComposition, completion:@escaping (_ avasset: AVAsset) -> Void){
    //        let exporter = AVAssetExportSession(asset: avComp, presetName: AVAssetExportPresetHighestQuality)
    //        let randNum:Int = Int(arc4random())
    //        //Generating Export Path
    //        let exportPath: NSString = NSTemporaryDirectory().appendingFormat("\(randNum)"+"video.mov") as NSString
    //        let exportUrl: NSURL = NSURL.fileURL(withPath: exportPath as String) as NSURL
    //        //SettingUp Export Path as URL
    //        exporter?.outputURL = exportUrl as URL
    //        exporter?.outputFileType = .mov
    //        exporter?.shouldOptimizeForNetworkUse = true
    //        exporter?.exportAsynchronously(completionHandler: {() -> Void in
    //            DispatchQueue.main.async(execute: {() -> Void in
    //                if exporter?.status == .completed {
    //                    let URL: URL? = exporter?.outputURL
    //                    let Avasset:AVAsset = AVAsset(url: URL!)
    //                    completion(Avasset)
    //                }
    //                else if exporter?.status == .failed {
    //                    print("Failed")
    //
    //                }
    //            })
    //        }) }
    
    func addComposition(asset: AVAsset, image: UIImage, url: URL){
        
        composition = AVMutableVideoComposition(asset: asset) { request in
            print("request is entered")
            
            //            let textImage = UIImage(systemName: "globe.europe.africa.fill")!
            //            let textImage = image
            let imageExample = CIImage(image: image)
            
            //            let positionedText = imageExample?.transformed(by: CGAffineTransform(translationX: 0, y: 0))
            let positionedText = imageExample?.transformed(by: .identity, highQualityDownsample: true)
            request.finish(with: (positionedText?.composited(over: request.sourceImage))!, context: nil)
        }
        
        test(currentAsset: asset, videoCompositionSoft: composition)

        
        //        let exporter = AVAssetExportSession(asset: asset, presetName: AVAssetExportPresetMediumQuality)
        //        exporter?.outputFileType = .mov
        //        exporter?.outputURL = url
        //        print("outputURL \(exporter?.outputURL)")
        ////        exporter?.videoComposition = composition
        ////        exporter?.customVideoCompositor = composition
        //
        //        exporter?.exportAsynchronously(completionHandler: { [weak self] in
        //            guard let export = exporter else {
        //                return
        //            }
        //
        //            switch export.status {
        //            case  .failed:
        //                print("failed \(export.error)")
        //                break
        //            case .cancelled:
        //                print("cancelled \(exporter?.error)")
        //                break
        //            case .completed:
        //                print("complete")
        //                let textItem = AVPlayerItem(asset: export.asset)
        //                textItem.videoComposition = export.videoComposition
        //                DispatchQueue.main.async { // Execute on main queue
        //                    self?.createVideoController(playerItem: textItem)
        //                }
        //            default:
        //                print("default")
        //            }
        //        })
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
        
        if let customText = addTextView?.exportTextImage() {
            print("exported image \(customText)")
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

