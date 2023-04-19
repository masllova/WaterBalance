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
          //  WaterDisplay.text = "\(Int(percent.rounded()))%"
            
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
        
        
        
        /*
       
         @IBAction func add100(_ sender: Any) {
         //case: (almost) full
         if Wave.hight < 90 {Wave.hight = 50}
         //case: append
         else {Wave.hight -= 40}
         percent += 5
         WaterDisplay.text = "\(Int(percent.rounded()))%"
         }
         
        
         @IBAction func add250(_ sender: Any) {
         //case: (almost) full
         if Wave.hight < 150 {Wave.hight = 50}
         //case: append
         else {Wave.hight -= 100}
         percent += 12.5
         WaterDisplay.text = "\(Int(percent.rounded()))%"
         
         }
         
         
         @IBAction func add500(_ sender: Any) {
         //case: (almost) full
         if Wave.hight < 250 {Wave.hight = 50}
         //case: append
         else {Wave.hight -= 200}
         percent += 25
         WaterDisplay.text = "\(Int(percent.rounded()))%"
         }
         */
    }
    
protocol MenuControllerDelegate: AnyObject {
    func changeInf(_ number1: Double, number2: Int)
    
}

class MenuController: UIViewController {
    weak var delegate: MenuControllerDelegate?
    
    
    @IBOutlet weak var menuView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        menuView.layer.cornerRadius = 20
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
    
    @IBAction func back(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
}
