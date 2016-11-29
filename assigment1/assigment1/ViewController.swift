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
    
    @IBOutlet var labelTemp: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        //superscript value
        let font:UIFont? = UIFont(name: "Helvetica", size:17)
        let fontSuper:UIFont? = UIFont(name: "Helvetica", size:10)
        let attString:NSMutableAttributedString = NSMutableAttributedString(string: "oF", attributes: [NSFontAttributeName:font!])
        attString.setAttributes([NSFontAttributeName:fontSuper!,NSBaselineOffsetAttributeName:8], range: NSRange(location:0,length:1))
        labelTemp.attributedText = attString;
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "ShowConvertSegue" {
            let farenheitTemp = Double(tempTextField.text!)
            if let destinationVC = segue.destinationViewController as? View2Controller {
                destinationVC.numberToDisplay = fahrenheitToCelcius(farenheitTemp!)
            }
        }
    }
    
    //Helper function to convert to Fahrenheit
    func fahrenheitToCelcius(fahrenheit:Double) -> Double {
        let celcius = Double(5.0 / 9.0 * (Double(fahrenheit) - 32.0))
        return Double(round(celcius * 100) / 100)
    }
    
    @IBAction func closeBtn(sender: UIButton) {
        exit(0);
    }
}

