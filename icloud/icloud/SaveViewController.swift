//
//  SaveViewController.swift
//  icloud
//
//  Created by Dao, Khanh on 11/22/16.
//  Copyright © 2016 cmpe297. All rights reserved.
//

import Foundation
import UIKit
import CloudKit

class SaveViewController: UIViewController {

    let database = CKContainer.defaultContainer().publicCloudDatabase //store public cloud
    var defaultKeyStore: NSUserDefaults? = NSUserDefaults.standardUserDefaults()
    let DefaultsTextKey = "DefaultsText"

    @IBOutlet var locationText: UITextField!
    @IBOutlet var reasonText: UITextField!
    @IBOutlet var descText: UITextView!

    override func viewDidLoad() {
        super.viewDidLoad()
        if !isIcloudAvailable() {
            print("iCloud is not available")
            displayAlertWithTitle("iCloud", message: "iCloud is not available." +
                " Please sign into your iCloud account and restart this app")
            return
        } else {
            print("iCloud is available")
        }
        localSetUp()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

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

    func getDate() -> String {
        let todaysDate:NSDate = NSDate()
        let dateFormatter:NSDateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "yyyy/MM/dd"
        let todayString:String = dateFormatter.stringFromDate(todaysDate)
        return todayString
    }

    @IBAction func saveLocalBtn(sender: UIButton) {
        saveLocally()
    }

    @IBAction func saveCloudBtn(sender: UIButton) {
        print("Save to iCloud...")
        let callData = CKRecord(recordType: "CallData")
        callData.setObject("Service Call " + getDate(), forKey: "name")
        callData.setObject(locationText.text!, forKey: "location")
        callData.setObject(reasonText.text!, forKey: "reason")
        callData.setObject(descText.text!, forKey: "description")
        /* Save this record publicly */
        database.saveRecord(callData, completionHandler: {
          (record: CKRecord?, error: NSError?) in
          if error != nil {
            print("Error occurred. Error = \(error)")
          } else {
            print("Successfully saved the record in the public database")
          }
        })
    }

    //Save locally (key)
    func generateLocalString() -> String {
        return locationText.text! + ", " + reasonText.text! + ", " + descText.text!
    }

    func localSetUp() {
        NSNotificationCenter.defaultCenter().removeObserver(self, name: NSUbiquitousKeyValueStoreDidChangeExternallyNotification, object: defaultKeyStore)
    }

    func saveLocally() {
        print("Save locally...")
        defaultKeyStore?.setObject(generateLocalString(), forKey: DefaultsTextKey)
        defaultKeyStore?.synchronize()
    }
}