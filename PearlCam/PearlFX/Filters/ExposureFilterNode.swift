//
//  ExposureFilterNode.swift
//  Accented
//
//  Created by Tiangong You on 6/9/17.
//  Copyright © 2017 Tiangong You. All rights reserved.
//

import UIKit
import GPUImage

class ExposureFilterNode: FilterNode {
    
    var expFilter = ExposureAdjustment()
    
    init() {
        super.init(filter: expFilter)
        enabled = true
    }
    
    var exposure : Float? {
        didSet {
            expFilter.exposure = exposure!
        }
    }
}
