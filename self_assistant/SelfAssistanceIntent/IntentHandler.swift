//
//  IntentHandler.swift
//  SelfAssistanceIntent
//
//  Created by Dao, Khanh on 12/5/16.
//  Copyright © 2016 cmpe297. All rights reserved.
//

import Intents
import EventKit

// As an example, this class is set up to handle Message intents.
// You will want to replace this or add other intents as appropriate.
// The intents you wish to handle must be declared in the extension's Info.plist.

// You can test your example integration by saying things to Siri like:
// "Send a message using <myApp>"
// "<myApp> John saying hello"
// "Search for messages in <myApp>"

class IntentHandler : INExtension {

    var eventStore: EKEventStore!
    var reminders: [EKReminder]!
    var selectedReminder: EKReminder!

    var uniqueFileName = "self_assistant.archive"
    var dataFilePath: String?
    
    override func handler(for intent: INIntent) -> Any? {
        print("testing")
        dataFilePath = fileInDocumentsDirectory(filename: uniqueFileName)
        print(dataFilePath!)
        self.eventStore = EKEventStore()
        self.reminders = [EKReminder]()
        self.eventStore.requestAccess(to: .event) { (granted, error) -> Void in
            if granted {
                let predicate = self.eventStore.predicateForReminders(in: nil)
                self.eventStore.fetchReminders(matching: predicate, completion: { (reminders: [EKReminder]?) -> Void in
                    self.reminders = reminders
                    let formatter:DateFormatter = DateFormatter()
                    formatter.dateFormat = "yyyy-MM-dd"
                    var obj:[String] = []
                    for reminder in self.reminders! {
                        if let dueDate = (reminder.dueDateComponents as NSDateComponents?)?.date{
                            obj.append(reminder.title + " - " + formatter.string(from: dueDate) + "\n")
                        } else{
                            obj.append(reminder.title + " - N/A\n")
                        }
                    }
                    NSKeyedArchiver.archiveRootObject(obj, toFile: self.dataFilePath!)
                })
            } else {
                print("The app is not permitted to access reminders, make sure to grant permission in the settings and try again")
            }
        }

        // Do any additional setup after loading the view, typically from a nib.
        return true
    }


    //Helper function to get directory URL
    func documentsDirectory() -> String {
        let documentsFolderPath = NSSearchPathForDirectoriesInDomains(FileManager.SearchPathDirectory.documentDirectory, FileManager.SearchPathDomainMask.userDomainMask, true)[0]
        return documentsFolderPath
    }

    //Helper function to get filepath
    func fileInDocumentsDirectory(filename: String) -> String {
        let writePath = (documentsDirectory() as NSString).appendingPathComponent("Mobile")
        //Check file if existing
        if (!FileManager.default.fileExists(atPath: writePath)) {
            do {
                try FileManager.default.createDirectory(atPath: writePath, withIntermediateDirectories: false, attributes: nil) }
            catch let error as NSError {
                print(error.localizedDescription);
            }
        }
        return (writePath as NSString).appendingPathComponent(filename)
    }
}
