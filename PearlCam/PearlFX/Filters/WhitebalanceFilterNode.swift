//
//  WhitebalanceFilterNode.swift
//  PearlCam
//
//  Created by Tiangong You on 6/10/17.
//  Copyright © 2017 Tiangong You. All rights reserved.
//

import UIKit
import GPUImage

class WhitebalanceFilterNode: FilterNode {
    
    var wbFilter = WhiteBalance()
    
    init() {
        super.init(filter: wbFilter)
        enabled = true
    }
    
    var temperature : Float? {
        didSet {
            wbFilter.temperature = temperature!
        }
    }
    
    var tint : Float? {
        didSet {
            wbFilter.tint = tint!
        }
    }
}
