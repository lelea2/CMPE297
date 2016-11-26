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
    
    var shouldDetect = false
    let motionManager = CMMotionManager()
    let activityManager = CMMotionActivityManager()
    var timer: Timer!
    let pedoMeter = CMPedometer()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        updateActivity()
//        countMotion()
        timer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(ViewController.countMotion), userInfo: nil, repeats: true)

    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //Function to update activity
    func updateActivity() {
        if(CMMotionActivityManager.isActivityAvailable()) {
        }
    }

    //Helper function to count step
    func countMotion() {
        if CMPedometer.isStepCountingAvailable() {
            print("support step count...")
            let fromDate = NSDate(timeIntervalSinceNow: -(10 * 60)) //10 mins ago
            pedoMeter.startUpdates(from: fromDate as Date, withHandler: { data, error in
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
        shouldDetect = true
    }


    @IBAction func stopBtn(_ sender: UIButton) {
        shouldDetect = false
    }


    @IBAction func closeBtn(_ sender: UIButton) {
        exit(0)
    }
}
