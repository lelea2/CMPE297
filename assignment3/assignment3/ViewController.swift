//
//  ViewController.swift
//  assignment3
//
//  Created by Dao, Khanh on 11/13/16.
//  Copyright © 2016 cmpe297. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet var bookNameField: UITextField!
    @IBOutlet var authorField: UITextField!
    @IBOutlet var descField: UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    

    @IBAction func saveStorage(sender: UIButton) {
    }

    @IBAction func saveArchive(sender: UIButton) {
    }
    
}

