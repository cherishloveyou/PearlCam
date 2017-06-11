//
//  VignetteFilterNode.swift
//  PearlCam
//
//  Created by Tiangong You on 6/10/17.
//  Copyright © 2017 Tiangong You. All rights reserved.
//

import UIKit
import GPUImage

class VignetteFilterNode: FilterNode {

    var vigFilter = Vignette()
    
    init() {
        super.init(filter: vigFilter)
        enabled = false
        vigFilter.end = 0.95
    }
    
    var radius : Float? {
        didSet {
            vigFilter.start = 1.0 - radius!
        }
    }

}
