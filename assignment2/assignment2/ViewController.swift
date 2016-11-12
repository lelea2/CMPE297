//
//  ViewController.swift
//  assignment2
//
//  Created by Dao, Khanh on 11/12/16.
//  Copyright © 2016 cmpe297. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet var studentIdField: UITextField!

    @IBOutlet var groupField: UITextField!
    
    @IBOutlet var bloodTypeField: UITextField!
    
    @IBOutlet var medicationField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


    @IBAction func saveArchiveBtn(sender: UIButton) {
    }
    
    
    @IBAction func openArchiveBtn(sender: UIButton) {
    }
    
}

