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
    
    var shouldDetect = false
    let motionManager = CMMotionManager()
    var timer: Timer!
    let pedoMeter = CMPedometer()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        countMotion()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    //Helper function to count step
    func countMotion() {
        if CMPedometer.isStepCountingAvailable() {
            print("support step count...")
            let yesterday = NSCalendar.current.date(byAdding: .day, value: -1, to: Date())
            pedoMeter.startUpdates(from: yesterday!, withHandler: { data, error in
                guard let data = data else {
                    return
                }
                print("check updating...")
                if error != nil {
                    print("There was an error obtaining pedometer data: \(error)")
                } else {
                    print("Start counting...")
                    print(data)
//                    DispatchQueue.main.async(execute: { () -> Void in
                        print("testing")
                        self.ascFloor.text = "\(data.floorsAscended!)"
                    self.descFloor.text = "\(data.floorsDescended!)"
                    self.stepCount.text = "\(data.numberOfSteps)"
                        self.distance.text = "\(data.distance!)"
    //                    self.distance.text = "\(self.stringFromMeters(data.distance as! Double))"
//                    })
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
