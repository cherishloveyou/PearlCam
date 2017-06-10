//
//  PearlFXViewController.swift
//  Accented
//
//  PearlFX is an advanced photo editor based on the awesome GPUImage project
//
//  Created by You, Tiangong on 6/8/17.
//  Copyright © 2017 Tiangong You. All rights reserved.
//

import UIKit
import GPUImage
import Photos

class PearlFXViewController: UIViewController, FilterSelectorViewDelegate, AdjustmentSelectorDelegate, AdjustmentUIDelegate {
    
    // The original image from the camera
    var originalImage : UIImage!
    var cameraPosition : AVCaptureDevicePosition
    
    @IBOutlet weak var editButton: UIButton!
    @IBOutlet weak var confirmButton: UIButton!
    @IBOutlet weak var backButton: UIButton!
    @IBOutlet weak var previewView: RenderView!
    @IBOutlet weak var filterSelectorView: FilterSelectorView!
    @IBOutlet weak var adjustmentSelectorView: AdjustmentSelectorView!
    
    // Rendering pipeline
    private var filterManager : FilterManager!
    private var previewInput : PictureInput!
    private var previewOutput : PictureOutput!
    private var previewImage : UIImage!
    
    // Presets
    private var presetThumbnailImage : UIImage!
    private var presetsInitialized = false
    
    // Adjustment filter UI
    private var currentAdjustmentUI : AdjustmentUIViewController?
    
    init(originalImage : UIImage, cameraPosition : AVCaptureDevicePosition) {
        self.cameraPosition = cameraPosition
        self.originalImage = originalImage
        super.init(nibName: "PearlFXViewController", bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initializePreview()
        filterSelectorView.delegate = self
        adjustmentSelectorView.delegate = self
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        if !presetsInitialized {
            presetsInitialized = true
            filterSelectorView.previewImage = presetThumbnailImage
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        return .portrait
    }
    
    private func initializePreview() {
        previewView.fillMode = .preserveAspectRatio
        
        // Calculate a fitting preview size
        let aspectRatio = originalImage.size.height / originalImage.size.width
        
        // Scale the image to match the screen size
        let w = view.bounds.width
        let h = w * aspectRatio
        
        let previewWidth = w * UIScreen.main.scale
        let previewHeight = h * UIScreen.main.scale
        
        // Create a preview with normalized orientation
        previewImage = createPreviewImage(w: previewWidth, h: previewHeight)
        previewImage = ImageUtils.fixOrientation(previewImage, width: previewWidth, height: previewHeight)!
        
        // The front camera always returns an image flipped, so we need to fix that
        if cameraPosition == .front {
            previewImage = ImageUtils.flipImage(previewImage)
        }
        
        // Create a preset thumbnail image
        let thumbnailWidth = FilterSelectorView.thumbnailSize
        let thumbnailHeight = FilterSelectorView.thumbnailSize * aspectRatio
        presetThumbnailImage = createPreviewImage(w: thumbnailWidth, h: thumbnailHeight)
        presetThumbnailImage = ImageUtils.fixOrientation(presetThumbnailImage, width: thumbnailWidth, height: thumbnailHeight)
        if cameraPosition == .front {
            presetThumbnailImage = ImageUtils.flipImage(presetThumbnailImage)
        }
        
        // Setup the initial render pipeline
        filterManager = FilterManager(originalImage: originalImage, previewImage: previewImage, renderView: previewView)
        filterSelectorView.filterManager = filterManager
        filterManager.renderPreview()
    }
    
    @IBAction func backButtonDidTap(_ sender: Any) {
        _ = navigationController?.popViewController(animated: true)
    }
    
    private func createPreviewImage(w : CGFloat, h : CGFloat) -> UIImage {
        if originalImage.size.width < w && originalImage.size.height < h {
            return originalImage
        }
        
        let image = originalImage.cgImage!
        let context = CGContext(data: nil, width: Int(w), height: Int(h), bitsPerComponent: image.bitsPerComponent, bytesPerRow: image.bytesPerRow, space: image.colorSpace!, bitmapInfo: image.bitmapInfo.rawValue)!
        context.interpolationQuality = .high
        let rect = CGRect(origin: CGPoint.zero, size: CGSize(width: w, height: h))
        context.draw(image, in: rect)
        let scaledImage = context.makeImage()!
        return UIImage(cgImage: scaledImage, scale: originalImage.scale, orientation: originalImage.imageOrientation)
    }
    
    // MARK: - FilterSelectorViewDelegate
    
    func didSelectColorPreset(_ colorPreset: String?) {
        filterManager.lookupImageName = colorPreset
    }
    
    @IBAction func confirmButtonDidTap(_ sender: Any) {
//        var image = ImageUtils.fixOrientation(originalImage, width: originalImage.size.width, height: originalImage.size.height)!
//        if cameraPosition == .front {
//            image = ImageUtils.flipImage(image)
//        }
//        
//        let input = PictureInput(image: image)
//        let output2 = PictureOutput()
//        
//        output2.encodedImageFormat = .jpeg
//        output2.encodedImageAvailableCallback = { (renderedData) in
//            PHPhotoLibrary.shared().performChanges( {
//                let creationRequest = PHAssetCreationRequest.forAsset()
//                creationRequest.addResource(with: PHAssetResourceType.photo, data: renderedData, options: nil)
//                }, completionHandler: { success, error in
//                    DispatchQueue.main.async {
//                        // Ignore
//                    }
//            })
//        }
//        
//        if let selectedPreset = filterSelectorView.selectedPreset {
//            let preset = selectedPreset as! LookupPreset
//            let filter = LookupPreset(preset.lookImageName).filter!
//            input --> filter --> output2
//        } else {
//            input --> output2
//        }
//        
//        input.processImage(synchronously: true)
    }

    private func presentAdjustmentUI(_ panel : AdjustmentUIViewController) {
        let previousPanel = currentAdjustmentUI
        currentAdjustmentUI = panel
        
        let contentHeight = adjustmentSelectorView.frame.minY
        addChildViewController(panel)
        panel.delegate = self
        panel.view.frame = CGRect(x: 0, y: 0, width: view.bounds.width, height: contentHeight)
        panel.view.alpha = 0
        panel.view.transform = CGAffineTransform(translationX: 0, y: 20)
        view.addSubview(panel.view)
        panel.didMove(toParentViewController: self)
        
        UIView.animate(withDuration: 0.2, animations: {
            panel.view.alpha = 1
            panel.view.transform = CGAffineTransform.identity
            
            if previousPanel != nil {
                previousPanel!.view.alpha = 0
            }
        }, completion: { [weak self] (finished) in
            if previousPanel != nil {
                previousPanel!.willMove(toParentViewController: nil)
                previousPanel!.view.removeFromSuperview()
                previousPanel!.removeFromParentViewController()
            }
            
            self?.currentAdjustmentUI = panel
        })
    }
    
    private func dismissCurrentAdjustmentUI(_ completionAction : (() -> Void)?) {
        if let currentPanel = currentAdjustmentUI {
            UIView.animate(withDuration: 0.2, animations: { 
                currentPanel.view.alpha = 0
            }, completion: { (finished) in
                currentPanel.willMove(toParentViewController: nil)
                currentPanel.view.removeFromSuperview()
                currentPanel.removeFromParentViewController()
                
                if completionAction != nil {
                    completionAction!()
                }
            })
        }
        
        currentAdjustmentUI = nil
    }
    
    // MARK: - AdjustmentSelectorDelegate
    
    func didRequestExposureFilterUI() {
        if currentAdjustmentUI != nil && currentAdjustmentUI! is BrightnessFilterViewController {
            dismissCurrentAdjustmentUI(nil)
            return
        }
        
        let panel = BrightnessFilterViewController(filterManager)
        presentAdjustmentUI(panel)
    }

    func didRequestWhiteBalanceFilterUI() {
        if currentAdjustmentUI != nil && currentAdjustmentUI! is WhiteBalanceFilterViewController {
            dismissCurrentAdjustmentUI(nil)
            return
        }
        
        let panel = WhiteBalanceFilterViewController(filterManager)
        presentAdjustmentUI(panel)
    }
    
    func didRequestMonochromeFilterUI() {
        if currentAdjustmentUI != nil && currentAdjustmentUI! is MonochromeFilterViewController {
            dismissCurrentAdjustmentUI(nil)
            return
        }
        
        let panel = MonochromeFilterViewController(filterManager)
        presentAdjustmentUI(panel)
    }
    
    // MARK: - AdjustmentUIDelegate
    func didRequestDismissCurrentAdjustmentUI() {
        dismissCurrentAdjustmentUI(nil)
    }
}
