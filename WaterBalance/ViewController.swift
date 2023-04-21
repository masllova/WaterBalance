//
//  ViewController.swift
//  WaterBalance
//
//  Created by Александра Маслова on 15.04.2023.
//

import UIKit
import CoreData

class ViewController: UIViewController, MenuControllerDelegate {
    var percent: Double = 0{
        didSet {
            if percent > 100 {percent = 100}
        }
    }
    @IBOutlet weak var Wave: WaveView!
    @IBOutlet weak var DropLet: UIImageView!
    @IBOutlet weak var WaterDisplay: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
            let request = NSFetchRequest<NSFetchRequestResult>(entityName: "Water")
            request.returnsObjectsAsFaults = false
            do {
                let result = try context.fetch(request)
                for data in result as! [NSManagedObject] {
                    if let percent = data.value(forKey: "percent") as? Double {
                        self.percent = percent
                    }
                    if let height = data.value(forKey: "height") as? Double {
                        Wave.height -= height
                    }
                }
            } catch {
                print("Failed")
            }
        updateWaterDisplay()
        
        DropLet.layer.cornerRadius = 20
        DropLet.layer.shadowRadius = 20
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            self.Wave.animationStart(direction: .right, speed: 10)
        }
        let calendar = Calendar(identifier: .gregorian)
            var components = DateComponents()
            components.calendar = calendar
            components.hour = 0
            components.minute = 0
            let midnight = calendar.nextDate(after: Date(), matching: components, matchingPolicy: .nextTime)!
            let timer = Timer(fireAt: midnight, interval: 0, target: self, selector: #selector(clearWater), userInfo: nil, repeats: true)
            RunLoop.main.add(timer, forMode: .common)
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
    func changeInf(_ number1: Double, number2: Double) {
        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        let entity = NSEntityDescription.entity(forEntityName: "Water", in: context)!
        let water = NSManagedObject(entity: entity, insertInto: context)
        
        water.setValue(number2, forKey: "height")
        
        self.percent += number1
        
        water.setValue(self.percent, forKey: "percent")
        
        do {
            try context.save()
        } catch let error as NSError {
            print("Could not save. \(error), \(error.userInfo)")
        }
        
        self.Wave.height -= number2
        
        updateWaterDisplay()
    }
    @objc func clearWater() {
         percent = 0
         Wave.height = 850
         updateWaterDisplay()
         
         let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
         let request = NSFetchRequest<NSFetchRequestResult>(entityName: "Water")
         request.returnsObjectsAsFaults = false
         do {
             let result = try context.fetch(request)
             for data in result as! [NSManagedObject] {
                 context.delete(data)
             }
             try context.save()
         } catch {
             print("Failed to clear water")
         }
     }
    
}
