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

    let database = CKContainer.default().publicCloudDatabase //store public cloud
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
            DispatchQueue.global(priority: DispatchQueue.GlobalQueuePriority.default).async {
                print(error)
                if error == nil {
                    self.callDatas = newData
                    self.tableView.reloadData()
                } else {
                    print("Fail to fetch")
                }
            }
        }
        CKContainer.default().publicCloudDatabase.add(operation)
    }

    //Function for table
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        cell.textLabel?.text = callDatas[indexPath.row].name
        return cell
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        print(self.callDatas.count)
        return self.callDatas.count
    }

    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }

    //End function for table

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


    //Check icloud is available
    func isIcloudAvailable() -> Bool {
        if let _ = FileManager.default.ubiquityIdentityToken{
            return true
        } else {
            return false
        }
    }

    //Helper function to display alert if icloud is not available
    func displayAlertWithTitle(_ title: String, message: String){
        let controller = UIAlertController(title: title,
            message: message,
            preferredStyle: .alert)

        controller.addAction(UIAlertAction(title: "OK",
            style: .default,
            handler: nil))

        present(controller, animated: true, completion: nil)
    }

    @IBAction func closeBtn(_ sender: UIButton) {
        exit(0);
    }

    //Default calldata class
    class CallData: NSObject {
        var name: String!
    }
}
