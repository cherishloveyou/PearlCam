//
//  AdjustmentSelectorView.swift
//  PearlCam
//
//  A panel that contains various advanced adjustment filters
//
//  Created by Tiangong You on 6/10/17.
//  Copyright © 2017 Tiangong You. All rights reserved.
//

import UIKit

protocol AdjustmentSelectorDelegate : NSObjectProtocol {
    func didRequestBrightnessFilterUI()
    func didRequestHighlightShadowFilterUI()
}

class AdjustmentSelectorView: UIView {
    private let buttonSize : CGFloat = 40
    private let gap : CGFloat = 10
    private let padding : CGFloat = 10

    private let scrollView = UIScrollView()
    private let contentView = UIView()

    private var brightnessFilterButton : UIButton!
    private var exposureFilterButton : UIButton!
    private var colorFilterButton : UIButton!
    private var whiteBalanceFilterButton : UIButton!
    private var fxFilterButton : UIButton!
    private var buttons = [UIButton]()

    weak var delegate : AdjustmentSelectorDelegate?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        initialize()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        initialize()
    }
    
    private func initialize() {
        addSubview(scrollView)
        scrollView.addSubview(contentView)

        // Create filter buttons
        brightnessFilterButton = createFilterButton("BrightnessFilterIcon")
        exposureFilterButton = createFilterButton("ExposureFilterIcon")
        colorFilterButton = createFilterButton("ColorFilterIcon")
        whiteBalanceFilterButton = createFilterButton("WhiteBalanceFilterIcon")
        fxFilterButton = createFilterButton("FXFilterIcon")
        buttons = [brightnessFilterButton, exposureFilterButton, colorFilterButton, whiteBalanceFilterButton, fxFilterButton]
        
        for button in buttons {
            contentView.addSubview(button)
        }
        
        // Events
        brightnessFilterButton.addTarget(self, action: #selector(brightnessButtonDidTap(_:)), for: .touchUpInside)
        exposureFilterButton.addTarget(self, action: #selector(highlightShadowButtonDidTap(_:)), for: .touchUpInside)
    }
    
    private func createFilterButton(_ icon : String) -> UIButton {
        let image = UIImage(named: icon)
        let button = UIButton()
        button.frame = CGRect(x: 0, y: 0, width: buttonSize, height: buttonSize)
        button.setImage(image, for: .normal)
        
        return button
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        scrollView.frame = self.bounds
        
        var nextX : CGFloat = padding
        let originY : CGFloat = bounds.height / 2 - buttonSize / 2
        for button in buttons {
            button.frame.origin.x = nextX
            button.frame.origin.y = originY
            button.frame.size = CGSize(width: buttonSize, height: buttonSize)
            
            nextX += FilterSelectorView.thumbnailSize + gap
        }
        
        let contentWidth : CGFloat = nextX + padding
        contentView.frame = CGRect(x: 0, y: 0, width: contentWidth, height: self.bounds.height)
        scrollView.contentSize = CGSize(width: contentWidth, height: self.bounds.height)
    }
    
    @objc private func brightnessButtonDidTap(_ sender : UIButton) {
        delegate?.didRequestBrightnessFilterUI()
    }
    
    @objc private func highlightShadowButtonDidTap(_ sender : UIButton) {
        delegate?.didRequestHighlightShadowFilterUI()
    }
}