//
//  View2Controller.swift
//  assigment1
//
//  Created by Dao, Khanh on 11/8/16.
//  Copyright © 2016 cmpe297. All rights reserved.
//

import Foundation
import UIKit

class View2Controller : UIViewController {

    var numberToDisplay = 0.0

    @IBOutlet var convertText: UILabel!
    
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        convertText.text = "Celcius:  \(numberToDisplay) oC."
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
  
}