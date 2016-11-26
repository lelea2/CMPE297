//
//  ViewController.swift
//  coremotion
//
//  Created by Dao, Khanh on 11/22/16.
//  Copyright © 2016 cmpe297. All rights reserved.
//

import UIKit
import Darwin
import CoreMotion

class ViewController: UIViewController {

    @IBOutlet var stepCount: UILabel!
    @IBOutlet var ascFloor: UILabel!
    @IBOutlet var descFloor: UILabel!
    @IBOutlet var distance: UILabel!
    
    @IBOutlet weak var activityText: UILabel!
    
    let activityManager = CMMotionActivityManager()
    var timer: Timer!
    var initialStartDate : NSDate?
    let pedoMeter = CMPedometer()
    var lastActivity : CMMotionActivity?
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func update() {
        updateActivity()
        countMotion()
    }
    
    //Function to update activity
    func updateActivity() {
        if(CMMotionActivityManager.isActivityAvailable()) {
            activityManager.startActivityUpdates(to: OperationQueue.main, withHandler: { (activity: CMMotionActivity?) -> Void in
                print(activity!)
                if activity?.stationary == false {
                    self.lastActivity = activity
                }
                var activityString = "Other activity type"
                
                if (activity?.stationary == true) {
                    activityString = "Stationary"
                }
                
                if (activity?.walking == true) {
                    activityString = "Walking"
                }
                
                if (activity?.running == true) {
                    activityString = "Running"
                }
                
                if (activity?.cycling == true) {
                    activityString = "Cycling"
                }
                DispatchQueue.main.async(execute: { () -> Void in
                    self.activityText.text = activityString
                })
            })
        }
    }

    //Helper function to count step
    func countMotion() {
        if CMPedometer.isStepCountingAvailable() {
            print("support step count...")
//            let fromDate = NSDate(timeIntervalSinceNow: -(1 * 60 * 60)) //1 hour ago
            if initialStartDate == nil {
                initialStartDate = NSDate(timeIntervalSinceNow: -(1 * 60 * 60)) //1 hour ago
            }
            pedoMeter.startUpdates(from: initialStartDate! as Date, withHandler: { data, error in
                guard let data = data else {
                    return
                }
                print("check updating...")
                if error != nil {
                    print("There was an error obtaining pedometer data: \(error)")
                } else {
                    print("Start counting...")
                    print(data)
                    DispatchQueue.main.async(execute: { () -> Void in
                        self.ascFloor.text = "\(data.floorsAscended!)"
                        self.descFloor.text = "\(data.floorsDescended!)"
                        self.stepCount.text = "\(data.numberOfSteps)"
                        var distance = data.distance?.doubleValue
                        distance = Double(round(100 * distance!) / 100)
                        self.distance.text = "\(distance!)"
                    })
                }
            })
        } else {
            print("Step count is not available")
        }
    }
    
    @IBAction func startBtn(_ sender: UIButton) {
        if initialStartDate == nil {
            initialStartDate = NSDate()
        }
        timer = Timer.scheduledTimer(timeInterval: 2.0, target: self, selector: #selector(ViewController.update), userInfo: nil, repeats: true)
    }

    @IBAction func stopBtn(_ sender: UIButton) {
        self.timer.invalidate()
        pedoMeter.stopUpdates()
    }


    @IBAction func closeBtn(_ sender: UIButton) {
        exit(0)
    }
}
