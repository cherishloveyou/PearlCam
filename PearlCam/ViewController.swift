//
//  ViewController.swift
//  PearlCam
//
//  Created by Tiangong You on 6/9/17.
//  Copyright © 2017 Tiangong You. All rights reserved.
//

import UIKit

class ViewController: UINavigationController {

    override func viewDidLoad() {
        super.viewDidLoad()
        self.isNavigationBarHidden = true

//        let vc = PearlCamViewController()
//        pushViewController(vc, animated: false)        
        let vc = PearlFXViewController(originalImage: UIImage(named: "test2.jpg")!, cameraPosition: .back)
        pushViewController(vc, animated: false)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

