//
//  ContrastFilterNode.swift
//  PearlCam
//
//  Contrast filter node
//
//  Created by Tiangong You on 6/10/17.
//  Copyright © 2017 Tiangong You. All rights reserved.
//

import UIKit
import GPUImage

class ContrastFilterNode: FilterNode {
    
    var contrastFilter = ContrastAdjustment()
    
    init() {
        super.init(filter: contrastFilter)
        enabled = true
    }
    
    var contrast : Float? {
        didSet {
            contrastFilter.contrast = contrast!
        }
    }
}

