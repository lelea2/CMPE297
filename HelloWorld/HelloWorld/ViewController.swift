//
//  ViewController.swift
//  HelloWorld
//
//  Created by Dao, Khanh on 11/1/16.
//  Copyright © 2016 cmpe297. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet var NameLabel: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    //parameter
    @IBAction func helloWorldAction(sender: UITextField) {
        NameLabel.text = "Hello, \(sender.text)"
    }

}

