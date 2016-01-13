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

extension Float {
    func format(f: String) -> String {
        return String(format: "%.\(f)f", self)
    }
}

extension Int{
    func toWeek() -> String{
        var weeks = ["Mon","Tues","Wednes", "Thurs", "Fri", "Sat", "Sun"]
        return weeks[self]+"day"
    }
}


class PickUpScheduleVC: UIViewController {
    
    var userSingelton = User.sharedInstance
    let defaultLocation:CLLocationCoordinate2D = CLLocationCoordinate2D()
    var customLocation:CLLocationCoordinate2D =  CLLocationCoordinate2D()
    var prevIndex = 0
    
    @IBOutlet weak var timeLbl: UILabel!
    @IBOutlet weak var slider: UISlider!
    @IBOutlet weak var switchToMap: UISwitch!
    @IBOutlet weak var weekSegment: UISegmentedControl!
    
    var scheduleDict:Dictionary<Int,(Float,String,CLLocationCoordinate2D)> = Dictionary<Int,(Float,String,CLLocationCoordinate2D)>()
    var pickUpPins = [PickUpPin]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        slider.maximumValue = 24;
        slider.minimumValue = 0;
        slider.setValue(0, animated: true)
        slider.continuous = true
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func convertToTimeString(value:Float)->String{
        let valueStr = "\(value)"
        let timeArr = valueStr.characters.split{$0 == "."}.map(String.init)
        let hours = Int(timeArr[0])!
        let minutes = Int(Float("0."+timeArr[1])!*60)
        let hoursStr = hours<10 ? "0\(hours)":"\(hours)"
        let minutesStr = ((minutes)<10) ? "0\(minutes)":"\((minutes))"
        return hoursStr+":"+minutesStr
    }

    @IBAction func sliderValueChanged(sender: AnyObject) {
        if(slider.value == 0.0){
            timeLbl.text = "No Pickup"
        }else{
            timeLbl.text =  convertToTimeString(slider.value)
        }
    }
    
    @IBAction func segmentedControlIndexChanged(sender: AnyObject) {
        let index = weekSegment.selectedSegmentIndex
        if(switchToMap.on){
            scheduleDict[prevIndex] = (slider.value,timeLbl.text!,defaultLocation)
        }else{
            scheduleDict[prevIndex] = (slider.value,timeLbl.text!,customLocation)
        }
        
        if(scheduleDict[index] != nil){
            timeLbl.text = scheduleDict[index]!.1
            slider.setValue(scheduleDict[index]!.0, animated: true)
        }else{
            slider.setValue(0, animated: true)
            timeLbl.text = "No Pickup"
        }
        
        switchToMap.setOn(true, animated: true)
        prevIndex = index
        
        switch weekSegment.selectedSegmentIndex{
        case 0:
            // Sunday
            break
        case 1:
            // Monday
            break
        case 2:
            // Tuesday
            break
        case 3:
            // Wednesday
            break
        case 4:
            // Thursday
            break
        case 5:
            // Friday
            break
        case 6:
            // Saturday
            break
        default:
            break;
        }
    }
    
    func printSchedule(){
        for schedule in scheduleDict{
            print("Day: \(schedule.0.toWeek()) Time: \(schedule.1.1) Location: \(schedule.1.2)");
        }

    }
    
    @IBAction func submitBtnPressed(sender: AnyObject) {
        printSchedule()
        scheduleDict[weekSegment.selectedSegmentIndex] = (slider.value,timeLbl.text!,defaultLocation)
        for schedule in scheduleDict{
            //Create PickUpPins Objects then append
            let pickUpPin = PickUpPin(coordinate: schedule.1.2, pickUpTime: schedule.1.1, driverName: userSingelton.getUserName(), driverMobile: userSingelton.getMobile(), driverID: userSingelton.getId())
            pickUpPins.append(pickUpPin)
        }
    }
    
    @IBAction func switchChangedState(sender: AnyObject) {
        if(!switchToMap.on){
            performSegueWithIdentifier("goToMapSegue", sender: self)
        }
    }
    
    @IBAction func unwindForGoToMapSegue(unwindSegue: UIStoryboardSegue, towardsViewController subsequentVC: UIViewController) {
        if let mapVC = unwindSegue.sourceViewController as? DriverVC{
           customLocation = mapVC.pinLocation
        }
    }
    
    
    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
    }

    
}