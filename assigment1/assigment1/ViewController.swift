//
//  ViewController.swift
//  assigment1
//
//  Created by Dao, Khanh on 11/8/16.
//  Copyright © 2016 cmpe297. All rights reserved.
//

import UIKit
import Darwin

class ViewController: UIViewController {

    @IBOutlet var tempTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func convertToCelsius(fahrenheit: Int) -> Int {
        return Int(5.0 / 9.0 * (Double(fahrenheit) - 32.0))
    }

    @IBAction func closeBtn(sender: UIButton) {
        exit(0);
    }
}

