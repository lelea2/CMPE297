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
    let font:UIFont? = UIFont(name: "Helvetica", size:17)
    let fontSuper:UIFont? = UIFont(name: "Helvetica", size:10)

    @IBOutlet var convertText: UILabel!
    
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        let str = "Celcius:  \(numberToDisplay) oC."
        let length = str.characters.count
        
        let attString:NSMutableAttributedString = NSMutableAttributedString(string: str, attributes: [NSFontAttributeName:font!])
        attString.setAttributes([NSFontAttributeName:fontSuper!,NSBaselineOffsetAttributeName:8], range: NSRange(location: length - 3,length:1))
        convertText.attributedText = attString
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