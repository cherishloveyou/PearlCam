//
//  MonochromeFilterNode.swift
//  PearlCam
//
//  Created by Tiangong You on 6/10/17.
//  Copyright © 2017 Tiangong You. All rights reserved.
//

import UIKit
import GPUImage

class MonochromeFilterNode: FilterNode {

    var monoFilter = MonochromeFilter()
    
    init() {
        super.init(filter: monoFilter)
        enabled = false
        monoFilter.color = Color(red: 0.5, green: 0.5, blue: 0.5)
    }
    
    var intensity : Float? {
        didSet {
            let colorValue = 1.0 - intensity!
            monoFilter.color = Color(red: colorValue, green: colorValue, blue: colorValue)
        }
    }
    
}
