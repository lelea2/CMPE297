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
    
    var days:[String] = []
    var stepsTaken:[Int] = []
    
    let lengthFormatter = LengthFormatter()


    override func viewDidLoad() {
        super.viewDidLoad()
        print("testing")
        countMotion()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    //Helper function to count step
    func countMotion() {
        print("call func")
        print(pedoMeter)
        pedoMeter.startUpdates(from: NSDate() as Date) {
            (data, error) in
            if error != nil {
                print("There was an error obtaining pedometer data: \(error)")
            } else {
                print("Start counting...")
                DispatchQueue.main.async(execute: { () -> Void in
                    print("testing")
                    self.ascFloor.text = "\(data?.floorsAscended)"
                    //self.descFloor.text = "\(data?.floorsDescended)"
                    self.stepCount.text = "\(data?.numberOfSteps)"
//                    self.distance.text = "\(self.stringFromMeters(data.distance as! Double))"
                })
            }
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
