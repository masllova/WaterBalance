//
//  WaterController.swift
//  WaterBalance
//
//  Created by Александра Маслова on 15.04.2023.
//

import UIKit
import CoreData

class WaterController: UIViewController, MenuControllerDelegate {
    var percent: Double = 0{
        didSet {if percent > 100 {percent = 100}}
    }
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    @IBOutlet weak var Wave: WaveView!
    @IBOutlet weak var DropLet: UIImageView!
    @IBOutlet weak var WaterDisplay: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        NotificationController().requestNotificationAuthorization()
        DropLet.layer.cornerRadius = 20
        DropLet.layer.shadowRadius = 20
        
        resetPercentIfNeeded()
        updateWaterDisplay()
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            self.Wave.animationStart(direction: .right, speed: 10)
        }
    }
    
    @IBAction func showAddWaterMenu(_ sender: Any) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        guard let menu = storyboard.instantiateViewController(withIdentifier: "menu") as? MenuController else { return }
        menu.delegate = self
        present(menu, animated: true, completion: nil)
        
    }
    
    func changeInf(_ value: Double) {
       let p = getPercent() + value
        setPercent(count: p)
        resetPercentIfNeeded()
        updateWaterDisplay()
    }
    
    func updateWaterDisplay() {
        let p = getPercent()
        WaterDisplay.text = "\(Int(p.rounded()))%"
        Wave.height = waterLevel(for: p)
    }
    
    func waterLevel(for percent: Double) -> Double {850 - (percent * 8)}
    
    func getPercent () -> Double {
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "Water")
        do {
            let result = try context.fetch(request) as! [NSManagedObject]
            if result.isEmpty {
                return 0.0
            } else {
                return result[0].value(forKey: "percent") as! Double
            }
        } catch {
            print("Error fetching count: \(error)")
            return 0.0
        }
    }
    

    func setPercent(count: Double) {
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "Water")
        do {
            let result = try context.fetch(request) as! [NSManagedObject]
            var newCount: NSManagedObject
            if result.isEmpty {
                newCount = NSEntityDescription.insertNewObject(forEntityName: "Water", into: context)
            } else {
                newCount = result[0]
            }
            
            let limitedCount = max(min(count, 100.0), 0.0)
            newCount.setValue(limitedCount, forKey: "percent")
            
            let currentDate = Date()
            newCount.setValue(currentDate, forKey: "timestamp")
            
            try context.save()
            
        } catch {
            print("Error saving count: \(error)")
        }
    }

    
    func resetPercentIfNeeded() {
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "Water")
        do {
            let result = try context.fetch(request) as! [NSManagedObject]
            if let lastEntry = result.last {
                if let lastEntryTimestamp = lastEntry.value(forKey: "timestamp") as? Date {
                    let calendar = Calendar.current
                    let now = Date()
                    let startOfToday = calendar.startOfDay(for: now)
                    if lastEntryTimestamp < startOfToday {
                        setPercent(count: 0)
                    }
                } else {
                    setPercent(count: 0)
                }
            } else {
                setPercent(count: 0)
            }
        } catch {
            print("Error checking timestamp: \(error)")
        }
    }
    
}
