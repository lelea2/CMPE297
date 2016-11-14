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
    
    @IBOutlet var bloodGroupField: UITextField!
    
    @IBOutlet var allergiesField: UITextView!
    
    @IBOutlet var medicationField: UITextView!
    
    @IBOutlet var btn1: UIButton!
    
    @IBOutlet var btn2: UIButton!
    
    var uniqueFileName = "assigment2.archive"
    var dataFilePath: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //Load file check
        dataFilePath = fileInDocumentsDirectory(uniqueFileName)
        print(dataFilePath)
        btnStyle(btn1)
        btnStyle(btn2)
        textStyle(studentIdField)
        textStyle(bloodGroupField)
        textAreaStyle(allergiesField)
        textAreaStyle(medicationField)
    }
    
    func textStyle(input : UITextField) {
        input.layer.borderWidth = 2
        input.layer.borderColor = UIColor.blueColor().CGColor
    }
    
    func textAreaStyle (input : UITextView) {
        input.layer.borderWidth = 2
        input.layer.borderColor = UIColor.blueColor().CGColor
    }
    
    func btnStyle(btn : UIButton) {
        btn.layer.cornerRadius = 10;
        btn.layer.borderWidth = 4;
        btn.layer.borderColor = UIColor.brownColor().CGColor
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    //Helper function to get directory URL
    func documentsDirectory() -> String {
        let documentsFolderPath = NSSearchPathForDirectoriesInDomains(NSSearchPathDirectory.DocumentDirectory, NSSearchPathDomainMask.UserDomainMask, true)[0]
        return documentsFolderPath
    }
    //Helper function to get filepath
    func fileInDocumentsDirectory(filename: String) -> String {
        let writePath = (documentsDirectory() as NSString).stringByAppendingPathComponent("Mobile")
        //Check file if existing
        if (!NSFileManager.defaultManager().fileExistsAtPath(writePath)) {
            do {
                try NSFileManager.defaultManager().createDirectoryAtPath(writePath, withIntermediateDirectories: false, attributes: nil) }
            catch let error as NSError {
                print(error.localizedDescription);
            }
        }
        return (writePath as NSString).stringByAppendingPathComponent(filename)
    }
    

    @IBAction func saveArchiveBtn(sender: UIButton) {
        let cardArr = [studentIdField.text, bloodGroupField.text, allergiesField.text, medicationField.text]
        NSKeyedArchiver.archiveRootObject(cardArr, toFile: dataFilePath!)
    }
    
    @IBAction func openArchiveBtn(sender: UIButton) {
        let dataArray = NSKeyedUnarchiver.unarchiveObjectWithFile(dataFilePath!) as! [String]
        studentIdField.text = dataArray[0]
        bloodGroupField.text = dataArray[1]
        allergiesField.text = dataArray[2]
        medicationField.text = dataArray[3]
    }
}

