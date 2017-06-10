//
//  LightShadowFilterViewController.swift
//  PearlCam
//
//  Created by Tiangong You on 6/10/17.
//  Copyright © 2017 Tiangong You. All rights reserved.
//

import UIKit

class LightShadowFilterViewController: AdjustmentUIViewController {

    @IBOutlet weak var highlightSlider: FXSlider!
    @IBOutlet weak var shadowSlider: FXSlider!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        highlightSlider.value = filterManager.highlight!
        shadowSlider.value = filterManager.shadow!
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    

    @IBAction func highlightValueDidChange(_ sender: Any) {
        filterManager.highlight = highlightSlider.value
    }
    
    @IBAction func shadowValueDidChange(_ sender: Any) {
        filterManager.shadow = highlightSlider.value
    }
}
