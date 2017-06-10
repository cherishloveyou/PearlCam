//
//  HighlightShadowFilterNode.swift
//  PearlCam
//
//  Created by Tiangong You on 6/10/17.
//  Copyright © 2017 Tiangong You. All rights reserved.
//

import UIKit
import GPUImage

class HighlightShadowFilterNode: FilterNode {
    
    var highlightShadowFilter = HighlightsAndShadows()
    
    init() {
        super.init(filter: highlightShadowFilter)
        enabled = true
    }
    
    var highlight : Float? {
        didSet {
            highlightShadowFilter.highlights = highlight!
        }
    }
    
    var shadow : Float? {
        didSet {
            highlightShadowFilter.shadows = shadow!
        }
    }

}
