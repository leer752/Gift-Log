//
//  PriorityControl.swift
//  Gift Log
//
//  Description: Sets up a custom class Priority Control derived from UIStackView that displays a set amount of stars
//      in a horizontal row. These stars can be tapped on by the user to set a "priority" rating for the gift.
//      A higher priority is a gift more highly desired by the person.
//
//  Created by Lee Rhodes on 8/15/19.
//  Copyright © 2019 Lee Rhodes. All rights reserved.
//

import UIKit

@IBDesignable class PriorityControl: UIStackView {
    
    // MARK: Properties
    
    private var priorityButtons = [UIButton]()
    
    // Priority always starts at 0 until it is updated.
    // If it is an existing gift, the updateButtonSelectionStates() puts its proper priority value on the button.
    var priority = 0 {
        didSet {
            updateButtonSelectionStates()
        }
    }
    
    // Setting & initializing default values for the Priority Control properties in the IB (Interface Builder).
    // IB lets user pick a star size and star count; these are just the starting/default values.
    @IBInspectable var starSize: CGSize = CGSize(width: 44.0, height: 44.0) {
        didSet {
            setupButtons()
        }
    }
    
    @IBInspectable var starCount: Int = 3 {
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
    
    // Performs the appropriate action when a star is tapped in the Priority Control.
    // Assigns that star as the new priority.
    // If the same priority is tapped, it resets the priority to 0.
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
    
    // Preparing the Priority Control display.
    // Loading images & updating the state of the stars if priority has already been set previously.
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
        
        
        for _ in 0..<starCount {
            let button = UIButton()
            button.setImage(starEmpty, for: .normal)
            button.setImage(starFilled, for: .selected)
            button.setImage(starHighlighted, for: .highlighted)
            button.setImage(starHighlighted, for: [.highlighted, .selected])
            
            button.translatesAutoresizingMaskIntoConstraints = false
            button.heightAnchor.constraint(equalToConstant: starSize.height).isActive = true
            button.widthAnchor.constraint(equalToConstant: starSize.width).isActive = true
            
            button.addTarget(self, action:
                #selector(PriorityControl.priorityButtonTapped(button:)), for: .touchUpInside)
            
            addArrangedSubview(button)
            
            priorityButtons.append(button)
        }
        
        updateButtonSelectionStates()
    }
    
    // Update how the star looks upon being pressed.
    // All of the selected stars should have an index less than the priority (since index starts at 0 & priority starts at 1).
    // i.e. if the priority is 2, then we know the stars with indexes 0 and 1 are selected. 
    private func updateButtonSelectionStates() {
        for (index, button) in priorityButtons.enumerated() {
            button.isSelected = index < priority
        }
    }
}
