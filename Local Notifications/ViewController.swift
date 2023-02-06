//
//  ViewController.swift
//  Local Notifications
//
//  Created by Aamer Essa on 28/11/2022.
//

import UIKit

class ViewController: UIViewController {
    @IBOutlet weak var totalTime: UILabel!
    @IBOutlet weak var TimeSetLabel: UILabel!
    @IBOutlet weak var workUntilLabel: UILabel!
    @IBOutlet weak var ActionNote: UILabel!
    @IBOutlet weak var stratTimerBtn: UIButton!
    @IBOutlet weak var timePicker: UIPickerView!
    
    @IBOutlet weak var DayTimersList: UITableView!
    var time = ["5 Minutes","10 Minutes","15 Minutes","20 Minutes","25 Minutes","30 Minutes","35 Minutes","40 Minutes","45 Minutes","50 Minutes","55 Minutes"]
    var totalTimesSets = [String]()
    var timeSelected = 0
    var total_Time = 0
    var hours = 0
    var showTabelList = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
    
        timePicker.dataSource = self
        timePicker.delegate = self
        DayTimersList.delegate = self
        DayTimersList.dataSource = self 
        totalTime.text = "Total Time: \(timeSelected)"
        ActionNote.isHidden = true
        TimeSetLabel.isHidden = true
        workUntilLabel.isHidden = true
        DayTimersList.isHidden = true
        DayTimersList.backgroundColor = .black
        
        
    }

    @IBAction func SetTimer(_ sender: Any) {
        // create the alert
               let alert = UIAlertController(title: "\(timeSelected) min countdown", message: "After \(timeSelected) Minutes, you'll be notified.\n Turn your ringer on.",        preferredStyle: UIAlertController.Style.alert)
                    alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
                    self.present(alert, animated: true)
        
              
       // calculate the date
            let date = Date()
            let dateFormatter = DateFormatter()
        
            //adding min
            let addminutes = date.addingTimeInterval(Double(timeSelected) * 60)
            dateFormatter.dateFormat = "hh:mm:ss a"
        
        // display the total times
        total_Time += timeSelected
        if total_Time >= 60 {
            total_Time = total_Time - 60
            hours += 1
            TimeSetLabel.text = "\(hours) hours, \(total_Time) min "
             } else {
                     TimeSetLabel.text = "\(hours) hours, \(total_Time) min "
               }
       
        // display the all contect
        TimeSetLabel.isHidden = false
        ActionNote.text = "\(timeSelected) minute timer set"
        ActionNote.isHidden = false
        totalTime.text = "Total Time: \(timeSelected)"
        workUntilLabel.text = "work Until:  \(dateFormatter.string(from: addminutes))"
        workUntilLabel.isHidden = false
        
       
        // add the timer into array to display into tabel
        totalTimesSets.append("\(dateFormatter.string(from: date)) - \(dateFormatter.string(from: addminutes)) (\(timeSelected) Minute timer)")
        print(totalTimesSets)
        
        // deleay the intel the timers up and then hided
        DispatchQueue.main.asyncAfter(deadline: .now() + Double(self.timeSelected * 60 ), execute: {
            self.workUntilLabel.isHidden = true
            
        })
        
        // setup the notification
        
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert,.sound]) {  authorized, error in
            if authorized {
                self.generateNotification(time: Double(self.timeSelected) * 60 )
            }
        } // end of UNUserNotificationCenter
       
    } // end of SetTimer
    
    
    @IBAction func CancelTimer(_ sender: Any) {
        
        // create the alert
               let alert = UIAlertController(title: "Cancel Current Timer", message: "Are you sure you want to cancel the current timer??", preferredStyle: UIAlertController.Style.alert)

               // add the actions (buttons)
               alert.addAction(UIAlertAction(title: "No", style: UIAlertAction.Style.default, handler: nil))
               alert.addAction(UIAlertAction(title: "Yes", style: UIAlertAction.Style.destructive, handler: { canceld in
                            self.ActionNote.text = "\(self.timeSelected) Minute Timer Cancelled"
                            self.workUntilLabel.isHidden = true
                            self.total_Time -= self.timeSelected
                            self.totalTime.text = "Total Time: 0"
                            self.TimeSetLabel.text = "\(self.hours) hours, \(self.total_Time) min"
                             self.totalTimesSets.removeLast()
                      }))
        
               // show the alert
               self.present(alert, animated: true, completion: nil)
        
    }// enf of CancelTimer()
    
    
    
    func generateNotification(time:TimeInterval){
        
        let notificationContent = UNMutableNotificationContent()
        notificationContent.title = "Times up 👏🏻"
        notificationContent.body = "Times up, take break 🧘🏻"
        notificationContent.sound = .default
        
        let notificationTrigger = UNTimeIntervalNotificationTrigger(timeInterval: TimeInterval(time), repeats: false)
        
        let request = UNNotificationRequest(identifier: "test", content: notificationContent, trigger: notificationTrigger)
        UNUserNotificationCenter.current().add(request)
        
    } // end of generateNotification
    
    
    @IBAction func AddNewDay(_ sender: Any) {
        
        // create the alert
        let alert = UIAlertController(title: "Add New Day ", message: "Are you sure it's a new day ??", preferredStyle: UIAlertController.Style.alert)

        // add the actions (buttons)
        alert.addAction(UIAlertAction(title: "Cancel", style: UIAlertAction.Style.cancel, handler: nil))
        alert.addAction(UIAlertAction(title: "New Day", style: UIAlertAction.Style.destructive, handler: { canceld in
                       self.total_Time = 0
                       self.timeSelected = 0
                       self.hours = 0
                       self.totalTime.text = "Total Time: \(self.timeSelected)"
                       self.ActionNote.isHidden = true
                       self.TimeSetLabel.isHidden = true
                       self.workUntilLabel.isHidden = true
                       self.totalTimesSets.removeAll()
                       self.timePicker.selectRow(0, inComponent: 0, animated: true)
               }))
        
        // show the alert
              self.present(alert, animated: true, completion: nil)
        
    } // end of AddNewDay()
    
    
    @IBAction func showTimersList(_ sender: Any) {
            
            ActionNote.isHidden = !showTabelList
            workUntilLabel.isHidden = !showTabelList
            timePicker.isHidden = !showTabelList
            stratTimerBtn.isHidden = !showTabelList
            DayTimersList.isHidden = showTabelList
            DayTimersList.reloadData()
            showTabelList = !showTabelList
    } //showTimersList() 
    
    
}

extension ViewController:UIPickerViewDelegate, UIPickerViewDataSource,UITableViewDelegate,UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return totalTimesSets.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = DayTimersList.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! TableViewCell
        cell.timerLabel.text = "\(totalTimesSets[indexPath.row])"
        return cell
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 90
    }
    
   
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
       return time.count
    }
    func pickerView(_ pickerView: UIPickerView, attributedTitleForRow row: Int, forComponent component: Int) -> NSAttributedString? {
        
        return NSAttributedString(string: time[row], attributes: [NSAttributedString.Key.foregroundColor : UIColor.white])
    }
       
     
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
       
        switch row {
        case 0: timeSelected = 5
        case 1: timeSelected = 10
        case 2: timeSelected = 15
        case 3: timeSelected = 20
        case 4: timeSelected = 25
        case 5: timeSelected = 30
        case 6: timeSelected = 35
        case 7: timeSelected = 40
        case 8: timeSelected = 45
        case 9: timeSelected = 50
        case 10: timeSelected = 55
        
        default:
            timeSelected = 5
        }
        print(timeSelected)
        
      
    }
    
}
