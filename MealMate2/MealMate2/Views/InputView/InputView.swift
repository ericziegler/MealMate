//
//  InputView.swift
//  MealMate2
//
//  Created by Eric Ziegler on 8/30/21.
//

import UIKit

// MARK: - Protocols

protocol InputViewDelegate {
    func groceryAdded(_ grocery: Grocery, forInputView inputView: InputView)
    func groceryUpdated(_ grocery: Grocery, indexPath: IndexPath, forInputView inputView: InputView)
    func inputViewCancelled(_ inputView: InputView)
}

class InputView: UIView {
    
    // MARK: - Properties
    
    @IBOutlet var bgView: UIView!
    @IBOutlet var titleLabel: BoldLabel!
    @IBOutlet var inputSegments: UISegmentedControl!
    @IBOutlet var inputField: AppTextField!
    @IBOutlet var addButton: BoldButton!
    @IBOutlet var cancelButton: BoldButton!
    
    private var grocery: Grocery?
    private var indexPath: IndexPath?
    private var delegate: InputViewDelegate?
    
    // MARK: - Init
    
    static func createInputFor(parentController: UIViewController, grocery: Grocery?, indexPath: IndexPath?, delegate: InputViewDelegate?) -> InputView {
        let input: InputView = UIView.fromNib()
        input.fillInParentView(parentView: parentController.view)
        input.grocery = grocery
        input.indexPath = indexPath
        input.delegate = delegate
        return input
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        inputField.backgroundColor = UIColor.appMedium
        inputField.styleField(textColor: UIColor.appDark, placeholderColor: UIColor.appMediumDark, cornerRadius: 8, font: inputField.font!)
    }

    // MARK: - Show / Hide Animations
    
    func showInput() {
        bgView.layer.cornerRadius = 8
        if let grocery = grocery {
            titleLabel.text = "Update Grocery"
            inputSegments.selectedSegmentIndex = grocery.category.rawValue
            inputField.text = grocery.name
            addButton.setTitle("UPDATE", for: .normal)
        } else {
            titleLabel.text = "Add Grocery"
            addButton.setTitle("ADD", for: .normal)
        }
        
        self.alpha = 0
        UIView.animate(withDuration: 0.15) {
            self.alpha = 1
        }
    }
    
    func hideInput() {
        UIView.animate(withDuration: 0.15, animations: {
            self.alpha = 0
        }) { didFinish in
            self.removeFromSuperview()
        }
    }
    
    // MARK: - Actions
    
    @IBAction func addTapped(_ sender: AnyObject) {
        var isUpdate = true
        if grocery == nil {
            grocery = Grocery()
            isUpdate = false
        }
        grocery!.name = inputField.text ?? ""
        grocery!.category = GroceryCategory(rawValue: inputSegments.selectedSegmentIndex)!
        
        if isUpdate == true {
            if let indexPath = self.indexPath {
                delegate?.groceryUpdated(grocery!, indexPath: indexPath, forInputView: self)
            }
        } else {
            delegate?.groceryAdded(grocery!, forInputView: self)
        }
    }
    
    @IBAction func cancelTapped(_ sender: AnyObject) {
        delegate?.inputViewCancelled(self)
    }
    
}
