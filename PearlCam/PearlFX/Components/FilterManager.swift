//
//  FilterManager.swift
//  Accented
//
//  Created by You, Tiangong on 6/9/17.
//  Copyright © 2017 Tiangong You. All rights reserved.
//

import UIKit
import GPUImage

class FilterManager: NSObject {

    // Color preset LUT image names
    let colorPresets = ["Intensify.png",
                        "CandleLight.png",
                        "ColorPunchCool.png",
                        "ColorPunch.png",
                        "Earthy.png",
                        "FilmStock.png",
                        "Lenox.png",
                        "Remy.png",
                        "lookup_amatorka.png",
                        "lookup_miss_etikate.png",
                        "lookup_soft_elegance_2.png"]
    
    private var originalImage : UIImage
    private var previewImage : UIImage
    private var previewView : RenderView
    private var previewInput : PictureInput!
    
    // Filters
    private var lookupNode = LookupFilterNode()
    private var exposureNode = ExposureFilterNode()
    private var contrastNode = ContrastFilterNode()
    private var vibranceNode = VibranceFilterNode()
    private var wbNode = WhitebalanceFilterNode()
    private var monochromeFilterNode = MonochromeFilterNode()
    
    // Filter pipelines
    private var previewPipeline : Pipeline!
    
    var lookupImageName : String? {
        didSet {
            if lookupImageName == nil {
                if lookupNode.enabled {
                    previewPipeline.invalidate()
                }
                
                lookupNode.enabled = false
                lookupNode.lookupImageName = nil
            } else {
                if !lookupNode.enabled {
                    previewPipeline.invalidate()
                }
                
                lookupNode.enabled = true
                lookupNode.lookupImageName = lookupImageName
            }
            
            renderPreview()
        }
    }
    
    var exposure : Float? = 0 {
        didSet {
            exposureNode.exposure = exposure
            renderPreview()
        }
    }
    
    var contrast : Float? = 1.0 {
        didSet {
            contrastNode.contrast = contrast
            renderPreview()
        }
    }
    
    var vibrance : Float? = 0 {
        didSet {
            vibranceNode.vibrance = vibrance
            renderPreview()
        }
    }
    
    var temperature : Float = 5000 {
        didSet {
            wbNode.temperature = temperature
            renderPreview()
        }
    }
    
    var tint : Float = 0 {
        didSet {
            wbNode.tint = tint
            renderPreview()
        }
    }
    
    var enableMonochrome : Bool = false {
        didSet {
            monochromeFilterNode.enabled = enableMonochrome
            previewPipeline.invalidate()
            renderPreview()
        }
    }
    
    var monochromeIntensity : Float = 0.7 {
        didSet {
            monochromeFilterNode.intensity = monochromeIntensity
            renderPreview()
        }
    }
    
    init(originalImage : UIImage, previewImage : UIImage, renderView : RenderView) {
        self.originalImage = originalImage
        self.previewImage = previewImage
        self.previewView = renderView
        super.init()
        
        initializePipelines()
    }

    private func initializePipelines() {
        previewPipeline = Pipeline()
        previewInput = PictureInput(image: previewImage)
        let inputNode = InputNode(input: previewInput)
        let outputNode = OutputNode(output: previewView)
        
        // Preview pipeline
        previewPipeline.addNode(inputNode)
        previewPipeline.addNode(wbNode)
        previewPipeline.addNode(exposureNode)
        previewPipeline.addNode(contrastNode)
        previewPipeline.addNode(vibranceNode)
        previewPipeline.addNode(lookupNode)
        previewPipeline.addNode(monochromeFilterNode)
        previewPipeline.addNode(outputNode)
    }
    
    func renderPreview() {
        previewPipeline.render()
    }
}
