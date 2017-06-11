//
//  ColorFilterNode.swift
//  PearlCam
//
//  Created by Tiangong You on 6/10/17.
//  Copyright © 2017 Tiangong You. All rights reserved.
//

import UIKit
import GPUImage

class ColorFilterNode: FilterNode {

    var rgbFilter = RGBAdjustment()
    
    init() {
        super.init(filter: rgbFilter)
        enabled = true
    }
    
    var red : Float? {
        didSet {
            rgbFilter.red = red!
        }
    }

    var green : Float? {
        didSet {
            rgbFilter.green = green!
        }
    }

    var blue : Float? {
        didSet {
            rgbFilter.blue = blue!
        }
    }

}
