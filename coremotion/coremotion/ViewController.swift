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
    let activityManager = CMMotionActivityManager()
    let pedoMeter = CMPedometer()

    override func viewDidLoad() {
        super.viewDidLoad()
        countStep()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    //Helper function to count step
    func countStep() {
        if CMPedometer.isStepCountingAvailable() {
            pedoMeter.startUpdates(from: NSDate() as Date, withHandler: {
                data, error in
                guard let data = data else {
                    return
                }
                print("Number of steps = \(data.numberOfSteps)")
              self.stepCount.text = (data.numberOfSteps.stringValue)
            })
        } else {
            print("Step counting is not available")
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
