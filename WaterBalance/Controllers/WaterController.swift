//
//  WaterController.swift
//  WaterBalance
//
//  Created by Александра Маслова on 15.04.2023.
//

import UIKit
import CoreData

class WaterController: UIViewController, MenuControllerDelegate {
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    @IBOutlet weak var Wave: WaveView!
    @IBOutlet weak var DropLet: UIImageView!
    @IBOutlet weak var WaterDisplay: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        NotificationController().requestNotificationAuthorization()
        DropLet.layer.cornerRadius = 20
        DropLet.layer.shadowRadius = 20
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            self.Wave.animationStart(direction: .right, speed: 10)
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
            super.viewWillAppear(animated)
            
            resetPercentIfNeeded()
            updateWaterDisplay()
        }
    
    @IBAction func showAddWaterMenu(_ sender: Any) {
        if WaterDisplay.text == "100%" {alert()}
        else {
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            guard let menu = storyboard.instantiateViewController(withIdentifier: "menu") as? MenuController else { return }
            menu.delegate = self
            present(menu, animated: true, completion: nil)

        }
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
    
    func getPercent() -> Double {
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "Water")
        request.sortDescriptors = [NSSortDescriptor(key: "timestamp", ascending: false)]
        request.fetchLimit = 1
        do {
            let result = try context.fetch(request) as! [NSManagedObject]
            if let lastEntry = result.last, let percent = lastEntry.value(forKey: "percent") as? Double {
                return percent
            } else {
                return 0.0
            }
        } catch {
            print("Error fetching count: \(error)")
            return 0.0
        }
    }

    func setPercent(count: Double) {
        let newCount = NSEntityDescription.insertNewObject(forEntityName: "Water", into: context)
        let limitedCount = max(min(count, 100.0), 0.0)
        newCount.setValue(limitedCount, forKey: "percent")
        let currentDate = Date()
        newCount.setValue(currentDate, forKey: "timestamp")
        do {
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
                } else {setPercent(count: 0)}
            } else {setPercent(count: 0)}
        } catch {
            print("Error checking timestamp: \(error)")
        }
    }
    
    func alert() {
        let alertController = UIAlertController(title: "Great job!", message: "Your goal for today is fulfilled", preferredStyle: .alert)
        let action = UIAlertAction(title: "ok", style: .default) { _ in
            print("ok")
        }
        alertController.addAction(action)
        present(alertController, animated: true) {print("alert")}
    }
}
