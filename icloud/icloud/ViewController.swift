//
//  ViewController.swift
//  icloud
//
//  Created by Dao, Khanh on 11/17/16.
//  Copyright © 2016 cmpe297. All rights reserved.
//

import UIKit
import Darwin
import CloudKit

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    let database = CKContainer.defaultContainer().publicCloudDatabase //store public cloud

    @IBOutlet var tableView: UITableView!

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        if !isIcloudAvailable() {
            print("iCloud is not available")
            displayAlertWithTitle("iCloud", message: "iCloud is not available." +
                " Please sign into your iCloud account and restart this app")
            return
        } else {
            print("iCloud is available")
        }
    }

//    let callData = CKRecord(recordType: "CallData")
//    callData.setObject("Service Call " + getDate(), forKey: "name")
//    callData.setObject(locationText.text!, forKey: "location")
//    callData.setObject(reasonText.text!, forKey: "reason")
//    callData.setObject(descText.text!, forKey: "description")
    func loadData() {

    }

    //Function for table
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 0 // your number of cell here
    }

    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        // your cell coding
        return UITableViewCell()
    }

    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        // cell selected code here
    }
    //End function for table

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


    //Check icloud is available
    func isIcloudAvailable() -> Bool {
        if let _ = NSFileManager.defaultManager().ubiquityIdentityToken{
            return true
        } else {
            return false
        }
    }

    //Helper function to display alert if icloud is not available
    func displayAlertWithTitle(title: String, message: String){
        let controller = UIAlertController(title: title,
            message: message,
            preferredStyle: .Alert)

        controller.addAction(UIAlertAction(title: "OK",
            style: .Default,
            handler: nil))

        presentViewController(controller, animated: true, completion: nil)
    }

    @IBAction func closeBtn(sender: UIButton) {
        exit(0);
    }
}
