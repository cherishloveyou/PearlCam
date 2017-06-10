//
//  SharpenFilterNode.swift
//  PearlCam
//
//  Created by Tiangong You on 6/10/17.
//  Copyright © 2017 Tiangong You. All rights reserved.
//

import UIKit
import GPUImage

class SharpenFilterNode: FilterNode {

    var sharpenFilter = Sharpen()
    
    init() {
        super.init(filter: sharpenFilter)
        enabled = true
    }
    
    var sharpness : Float? {
        didSet {
            sharpenFilter.sharpness = sharpness!
        }
    }

    
}
