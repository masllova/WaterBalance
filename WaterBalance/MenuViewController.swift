//
//  MenuViewController.swift
//  WaterBalance
//
//  Created by Александра Маслова on 19.04.2023.
//

import UIKit


class MenuViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.isModalInPresentation = true
        
    }
    
    @IBAction func addWater(_ sender: Any) {
        dismiss(animated: true)
    }
    
}

