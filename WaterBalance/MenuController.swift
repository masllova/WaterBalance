//
//  MenuController.swift
//  WaterBalance
//
//  Created by Александра Маслова on 21.04.2023.
//

import UIKit

class MenuController: UIViewController {
    weak var delegate: MenuControllerDelegate?
    var selectedSegment = "100ml"
    
    @IBOutlet weak var menuView: UIView!
    @IBOutlet weak var segmentedcontrol: UISegmentedControl!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        menuView.layer.cornerRadius = 20
        segmentedcontrol.setTitleTextAttributes([.foregroundColor: UIColor.white], for: .selected)
        segmentedcontrol.setTitleTextAttributes([.foregroundColor: UIColor(named: "darkBlueColor")!], for: .normal)
    }
    
    @IBAction func selectedWaterVolume(_ sender: UISegmentedControl) {
        switch sender.selectedSegmentIndex {
        case 0: selectedSegment = "100ml"
        case 1: selectedSegment = "250ml"
        case 2: selectedSegment = "500ml"
        default:
            break
        }
    }
    
    @IBAction func addWater(_ sender: Any) {
        if selectedSegment == "100ml" {delegate?.changeInf(5.0, number2: 40)}
        if selectedSegment == "250ml" {delegate?.changeInf(12.5, number2: 100)}
        if selectedSegment == "500ml" {delegate?.changeInf(25.0, number2: 200)}
        else {dismiss(animated: true, completion: nil)}
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func back(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
}

protocol MenuControllerDelegate: AnyObject {
    func changeInf(_ number1: Double, number2: Int)
}
