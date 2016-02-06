//
//  DayScheduleVC.swift
//  CarPooling
//
//  Created by Badr AlKhamissi on 2/3/16.
//  Copyright © 2016 Badr AlKhamissi. All rights reserved.
//



import Foundation
import UIKit
import Parse


class DayScheduleVC: UIViewController {
    
    var dayOfTheWeek = ""
    @IBOutlet weak var dayOfTheWeekLbl: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        dayOfTheWeekLbl.text = dayOfTheWeek
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
}