//
//  DropOffScheduleVC.swift
//  CarPooling
//
//  Created by Ali Sultan on 1/18/16.
//  Copyright © 2016 Badr AlKhamissi. All rights reserved.
//

//
//  PickUpScheduleVC.swift
//  CarPooling
//
//  Created by Badr AlKhamissi on 1/13/16.
//  Copyright © 2016 Badr AlKhamissi. All rights reserved.
//

import Foundation
import UIKit
import Parse


import UIKit

class DropOffScheduleVC: UIViewController {
    
    var userSingelton = User.sharedInstance
    var defaultLocation:CLLocationCoordinate2D = CLLocationCoordinate2D()
    var customLocation:CLLocationCoordinate2D?
    var prevIndex = 0
    
    @IBOutlet weak var timeLbl: UILabel!
    @IBOutlet weak var slider: UISlider!
    @IBOutlet weak var switchToMap: UISwitch!
    @IBOutlet weak var weekSegment: UISegmentedControl!
    @IBOutlet weak var customLocationLabel: UILabel!
    
    var scheduleDict:Dictionary<Int,(Float,String,CLLocationCoordinate2D,String)> = Dictionary<Int,(Float,String,CLLocationCoordinate2D,String)>()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        slider.maximumValue = 21;
        slider.minimumValue = 5;
        slider.setValue(0, animated: true)
        slider.continuous = true
        for i in 0...6 {
            scheduleDict[i] = (5,"No Pick Up",defaultLocation,"No Custom Location Set")
        }
    }
    
    override func viewWillAppear(animated: Bool) {
        if UIDevice.currentDevice().valueForKey("orientation") as! Int != UIInterfaceOrientation.LandscapeLeft.rawValue {
            UIDevice.currentDevice().setValue(UIInterfaceOrientation.LandscapeLeft.rawValue, forKey: "orientation")
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func convertToTimeString(value:Float)->String{
        let valueStr = "\(value)"
        let timeArr = valueStr.componentsSeparatedByString(".");
        var hours = Int(timeArr[0])!
        let minutes = Int(Float("0."+timeArr[1])!*60) - Int(Float("0."+timeArr[1])!*60)%5
        let am_pm_identifier : String?
        if hours>=12 && minutes>=0 {
            hours -= 12
            am_pm_identifier = "PM"
        }else{
            am_pm_identifier = "AM"
        }
        let hoursStr = hours<10 ? "0\(hours)":"\(hours)"
        let minutesStr = ((minutes)<10) ? "0\(minutes)":"\((minutes))"
        return hoursStr+":"+minutesStr+" "+am_pm_identifier!
    }
    
    func getSecondsFrom(value: Float) -> Int {
        let valueStr = "\(value)"
        let timeArr = valueStr.componentsSeparatedByString(".")
        let hours = Int(timeArr[0])!
        let hoursAsSeconds = hours*60*60
        let minutes : Int = Int("0.\(timeArr[1])".toFloat()*60) - Int(("0.\(timeArr[1])".toFloat()*60)%5)
        let minutesAsSeconds = minutes*60
        return hoursAsSeconds+minutesAsSeconds
    }
    
    @IBAction func sliderValueChanged(sender: AnyObject) {
        if(slider.value == slider.minimumValue){
            timeLbl.text = "No Drop Off"
        }else{
            timeLbl.text =  convertToTimeString(slider.value)
        }
    }
    
    @IBAction func segmentedControlIndexChanged(sender: AnyObject) {
        let index = weekSegment.selectedSegmentIndex
        if(switchToMap.on){
            scheduleDict[prevIndex] = (slider.value,timeLbl.text!,defaultLocation,customLocationLabel.text!)
        }else{
            scheduleDict[prevIndex] = (slider.value,timeLbl.text!,customLocation!,customLocationLabel.text!)
        }
        timeLbl.text = scheduleDict[index]!.1
        slider.setValue(scheduleDict[index]!.0, animated: true)
        if scheduleDict[index]!.3 != "No Custom Location Set" {
            customLocationLabel.text = scheduleDict[index]!.3
            switchToMap.setOn(false, animated: true)
        }else {
            switchToMap.setOn(true, animated: true)
            customLocationLabel.text = "No Custom Location Set"
        }
        prevIndex = index
    }
    
    func printSchedule(){
        for schedule in scheduleDict{
            print("Day: \(schedule.0.toWeek()) Time: \(schedule.1.1) Location: \(schedule.1.2)");
        }
    }
    
    @IBAction func submitBtnPressed(sender: AnyObject) {
        userSingelton.dropOffSchedule.removeAll()
        scheduleDict[weekSegment.selectedSegmentIndex] = (slider.value,timeLbl.text!,defaultLocation,customLocationLabel.text!)
        for schedule in scheduleDict{
            if(schedule.1.1 != "No Drop Off"){
                //Create PickUpPins Objects then append
                let weekDay = schedule.0.toWeek()
                let pickUpTimeInSecondsAsString = "\(getSecondsFrom(schedule.1.0))"
                let pickUpTimeWithDayAsString = weekDay + " " + pickUpTimeInSecondsAsString
                
                let pin = PickUpPin(coordinate: schedule.1.2, pickUpTime: pickUpTimeWithDayAsString, driverName: userSingelton.getFullName(), driverMobile: userSingelton.getMobile(), driverID: userSingelton.getId())
                userSingelton.dropOffSchedule.append(pin)
            }
        }        
    }
    
    @IBAction func switchChangedState(sender: AnyObject) {
        if(!switchToMap.on){
            performSegueWithIdentifier("goToMapSegue", sender: self)
        }
        else{
            customLocationLabel.text = "No Custom Location Set"
        }
    }
    
    @IBAction func unwindForGoToMapSegue(unwindSegue: UIStoryboardSegue, towardsViewController subsequentVC: UIViewController) {
        if let mapVC = unwindSegue.sourceViewController as? DriverVC{
            customLocation = mapVC.pointAnnotation.coordinate
            customLocationLabel.text = mapVC.pointAnnotation.title
        }
    }

    
    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
    }
    

}
