//
//  ViewController.swift
//  falldetect
//
//  Created by Dao, Khanh on 11/22/16.
//  Copyright © 2016 cmpe297. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    var shouldDetect = false;

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


    @IBAction func startBtn(sender: UIButton) {
        shouldDetect = true
    }


    @IBAction func stopBtn(sender: UIButton) {
        shouldDetect = false
    }

}

