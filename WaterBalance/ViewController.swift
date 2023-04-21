//
//  ViewController.swift
//  WaterBalance
//
//  Created by Александра Маслова on 15.04.2023.
//

import UIKit
class ViewController: UIViewController, MenuControllerDelegate {
    var percent: Double = 0
    
    @IBOutlet weak var Wave: WaveView!
    @IBOutlet weak var DropLet: UIImageView!
    @IBOutlet weak var WaterDisplay: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        updateWaterDisplay()
        
        DropLet.layer.cornerRadius = 20
        DropLet.layer.shadowRadius = 20
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            self.Wave.animationStart(direction: .right, speed: 10)
        }
    }
    
    func updateWaterDisplay() {
        WaterDisplay.text = "\(Int(percent.rounded()))%"
    }
    
    
    @IBAction func showAddWaterMenu(_ sender: Any) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        guard let menu = storyboard.instantiateViewController(withIdentifier: "menu") as? MenuController else { return }
        menu.delegate = self
        present(menu, animated: true, completion: nil)
        
    }
    func changeInf(_ number1: Double, number2: Int) {
        self.percent += number1
        if self.percent >= 100 {self.percent = 100}
        Wave.height -= number2
        if Wave.height <= 50 {Wave.height = 50}
        
        updateWaterDisplay()
    }
}
    


