//
//  ViewController.swift
//  icloud
//
//  Created by Dao, Khanh on 11/17/16.
//  Copyright © 2016 cmpe297. All rights reserved.
//

import Foundation
import Dispatch
import UIKit
import Darwin
import CloudKit

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    let database = CKContainer.defaultContainer().publicCloudDatabase //store public cloud
    var callDatas = [CallData]()

    @IBOutlet var tableView: UITableView!

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        loadData()
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
        print("Loading data...")
        let pred = NSPredicate(value: true)
        let query = CKQuery(recordType: "CallData", predicate: pred)
        let operation = CKQueryOperation(query: query)
        var newData = [CallData]()
        operation.desiredKeys = ["name"]
        operation.resultsLimit = 50
        operation.recordFetchedBlock = { record in
            let data = CallData()
            data.name = record["name"] as! String
            newData.append(data)
        }
        operation.queryCompletionBlock = { [unowned self] (cursor, error) in
            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)) {
                if error == nil {
                    self.callDatas = newData
                    self.tableView.reloadData()
                } else {
                    print("Fail to fetch")
                }
            }
        }
        CKContainer.defaultContainer().publicCloudDatabase.addOperation(operation)
    }

    //Function for table
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("Cell", forIndexPath: indexPath)
        cell.textLabel?.text = callDatas[indexPath.row].name
        return cell
    }

    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        print(self.callDatas.count)
        return self.callDatas.count
    }

    func tableView(tableView: UITableView, estimatedHeightForRowAt indexPath: NSIndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }

    func tableView(tableView: UITableView, heightForRowAt indexPath: NSIndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
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

    //Default calldata class
    class CallData: NSObject {
        var name: String!
    }
}
