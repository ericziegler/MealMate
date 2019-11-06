//
//  ViewController.swift
//  MealMate
//

import UIKit

class ViewController: BaseViewController {

    @IBOutlet var gradient: GradientView!

    override func viewDidLoad() {
        super.viewDidLoad()
        let x = UIColor(intRed: 44, green: 34, blue: 173)
        let y = UIColor(intRed: 180, green: 105, blue: 209)
        gradient.updateGradientWith(firstColor: x, secondColor: y)
    }


}

