//
//  ViewController.swift
//  falldetect
//
//  Created by Dao, Khanh on 11/22/16.
//  Copyright © 2016 cmpe297. All rights reserved.
//

//Testing concept referenced from http://stackoverflow.com/questions/14445914/detect-programmatically-if-iphone-is-dropped-using-coremotion-accelerometer

import UIKit
import CoreMotion
import Darwin

class ViewController: UIViewController {

    @IBOutlet var detectText: UILabel!
    
    var motionManager = CMMotionManager()
    var detected = false

    override func viewDidLoad() {
        super.viewDidLoad()

        motionManager.gyroUpdateInterval = 0.2
        motionManager.accelerometerUpdateInterval = 0.2
        motionManager.deviceMotionUpdateInterval = 0.1
//        self.detectAccel()
    }
    
//    func detectDeviceMotion() {
//        motionManager.startDeviceMotionUpdates(to: OperationQueue(), withHandler: {
//            (deviceMotion, error) -> Void in
//            if(error == nil) {
//                print(deviceMotion)
//            } else {
//                //handle the error
//            }
//        })
//    }
    
    func detectAccel() {
        self.detectText.text = "Detecting..."
        motionManager.startAccelerometerUpdates(to: OperationQueue()) { (accelerometerData: CMAccelerometerData?, NSError) -> Void in
            let acceleration = accelerometerData!.acceleration
            let a = pow(acceleration.x, 2) + pow(acceleration.y, 2) + pow(acceleration.z, 2)
            print(a)
            //By theory, if a drop to 0, mean phone is dropping
            DispatchQueue.main.async(execute: { () -> Void in
                if (a < 0.1) {
                    self.detectText.text = "Detected"
                    print("Detect phone fall...")
                    self.motionManager.stopAccelerometerUpdates()
                } else {
                    //phone not drop
                }
            })
            if(NSError != nil) {
                print("\(NSError)")
            }
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


    @IBAction func startBtn(_ sender: UIButton) {
        self.detectAccel()
    }


    @IBAction func stopBtn(_ sender: UIButton) {
//        detected = false
        detectText.text = "Not Detected"
        motionManager.stopAccelerometerUpdates() //Stop update
    }

}
