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
      //  view.layer.masksToBounds = true
    }

    
    //The minimum step of adding water is 50 ml, which is equal to reducing the growth variable by 40. The filled drop is the value of the variable is 50, and the empty drop is 850
    
    @IBAction func add100ml(_ sender: Any) {
        delegate?.changeInf(5.0, number2: 40)
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func add250ml(_ sender: Any) {
        delegate?.changeInf(12.5, number2: 100)
        dismiss(animated: true, completion: nil)
    }
    
    
    @IBAction func add500ml(_ sender: Any) {
        delegate?.changeInf(25.0, number2: 200)
        dismiss(animated: true, completion: nil)
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
