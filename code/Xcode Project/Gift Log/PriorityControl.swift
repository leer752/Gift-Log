//
//  PriorityControl.swift
//  Gift Log
//
//  Created by Lee Rhodes on 8/15/19.
//  Copyright © 2019 Lee Rhodes. All rights reserved.
//

import UIKit

@IBDesignable class PriorityControl: UIStackView {
    
    // MARK: Properties
    
    private var priorityButtons = [UIButton]()
    
    var priority = 0 {
        didSet {
            updateButtonSelectionStates()
        }
    }
    
    @IBInspectable var exclamationPointSize: CGSize = CGSize(width: 44.0, height: 44.0) {
        didSet {
            setupButtons()
        }
    }
    
    @IBInspectable var exclamationPointCount: Int = 3 {
        didSet {
            setupButtons()
        }
    }

    // MARK: Initialization
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupButtons()
    }

    required init(coder: NSCoder) {
        super.init(coder: coder)
        setupButtons()
    }
    
    @objc func priorityButtonTapped(button: UIButton) {
        guard let index = priorityButtons.index(of: button) else {
            fatalError("The button, \(button), is not in the PriorityButtons array: \(priorityButtons)")
        }
        
        let selectedPriority = index + 1
        
        if selectedPriority == priority {
            priority = 0
        } else {
            priority = selectedPriority
        }
    }
    
    // MARK: Private methods
    
    private func setupButtons() {
        for button in priorityButtons {
            removeArrangedSubview(button)
            button.removeFromSuperview()
        }
        priorityButtons.removeAll()
        
        let bundle = Bundle(for: type(of: self))
        let starFilled = UIImage(named: "starFilled", in: bundle, compatibleWith: self.traitCollection)
        let starEmpty = UIImage(named: "starEmpty", in: bundle, compatibleWith: self.traitCollection)
        let starHighlighted = UIImage(named: "starHighlighted", in: bundle, compatibleWith: self.traitCollection)
        
        
        for _ in 0..<exclamationPointCount {
            let button = UIButton()
            button.setImage(starEmpty, for: .normal)
            button.setImage(starFilled, for: .selected)
            button.setImage(starHighlighted, for: .highlighted)
            button.setImage(starHighlighted, for: [.highlighted, .selected])
            
            button.translatesAutoresizingMaskIntoConstraints = false
            button.heightAnchor.constraint(equalToConstant: exclamationPointSize.height).isActive = true
            button.widthAnchor.constraint(equalToConstant: exclamationPointSize.width).isActive = true
            
            button.addTarget(self, action:
                #selector(PriorityControl.priorityButtonTapped(button:)), for: .touchUpInside)
            
            addArrangedSubview(button)
            
            priorityButtons.append(button)
        }
        
        updateButtonSelectionStates()
    }
    
    private func updateButtonSelectionStates() {
        for (index, button) in priorityButtons.enumerated() {
            button.isSelected = index < priority
        }
    }
}
