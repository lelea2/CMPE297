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
    
    func generateString() -> String {
        let str = bookNameField.text! + ", " + authorField.text! + ", " + descField.text!
        return str
    }

    func getDocDirectory() -> URL {
        // get the documents folder url
        let documentDirectoryURL = try! FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: true)
        return documentDirectoryURL
    }

    @IBAction func saveStorage(_ sender: UIButton) {
        // get the documents folder url
        let documentDirectoryURL = getDocDirectory() // create the destination url for the text file to be saved
        let fileDestinationUrl = documentDirectoryURL.appendingPathComponent("Assigment3_FileManager.txt")
        print(fileDestinationUrl.path) //print file path
        let text = generateString()
        
        do {
            // writing to disk
            try text.write(to: fileDestinationUrl, atomically: false, encoding: String.Encoding.utf8)
            
            // saving was successful. any code posterior code goes here
            
            // reading from disk
            do {
                let mytext = try String(contentsOf: fileDestinationUrl, encoding: String.Encoding.utf8)
                print(mytext)   // "some text\n"
            } catch let error as NSError {
                print("error loading from url \(fileDestinationUrl)")
                print(error.localizedDescription)
            }
        } catch let error as NSError {
            print("error writing to url \(fileDestinationUrl)")
            print(error.localizedDescription)
        }
    }

    @IBAction func saveArchive(_ sender: UIButton) {
        let documentDirectoryURL = getDocDirectory() // create the destination url for the text file to be saved
        let fileDestinationUrl = documentDirectoryURL.appendingPathComponent("Assigment3_Archive.txt").path
        print(fileDestinationUrl) //print file path
        let text = generateString()
        NSKeyedArchiver.archiveRootObject(text, toFile: fileDestinationUrl)
    }
    
}

