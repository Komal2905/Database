//
//  ViewController.swift
//  Database
//
//  Created by Vidya Ramamurthy on 12/01/16.
//  Copyright © 2016 BridgeLabz. All rights reserved.
//

import UIKit
import CoreData

class ViewController: UIViewController {

    @IBOutlet weak var name: UITextField!
    
    
    @IBOutlet weak var address: UITextField!
    
    @IBOutlet weak var phoneNo: UITextField!
    
    @IBOutlet weak var status: UILabel!
    
    var databasePath = NSString()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        let filemgr = NSFileManager.defaultManager()
        let dirPaths = NSSearchPathForDirectoriesInDomains(.DocumentDirectory,
            .UserDomainMask, true)
         print("DIrpath ",dirPaths)
        
        let docsDir = dirPaths[0] as! NSString // String
        
        
//        let documentsURL = NSFileManager.defaultManager().URLsForDirectory(.DocumentDirectory, inDomains: .UserDomainMask)[0]
//        let fileURL = documentsURL.URLByAppendingPathComponent("test.sqlite")
        
        
        databasePath = docsDir.stringByAppendingPathComponent(
            "contacts.db")
        
        if !filemgr.fileExistsAtPath(databasePath as String) {
            
            let contactDB = FMDatabase(path: databasePath as String)
            print("path ", contactDB)
            if contactDB == nil {
                print("Error: \(contactDB.lastErrorMessage())")
            }
            
            if contactDB.open() {
                
                let sql_stmt = "CREATE TABLE IF NOT EXISTS CONTACTS (ID INTEGER PRIMARY KEY AUTOINCREMENT, NAME TEXT, ADDRESS TEXT, PHONE TEXT)"
                if !contactDB.executeStatements(sql_stmt) {
                    print("Error: \(contactDB.lastErrorMessage())")
                }
                contactDB.close()
            } else {
                print("Error: \(contactDB.lastErrorMessage())")
            }
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func saveData(sender: AnyObject) {
        
        
        let contactDB = FMDatabase(path : databasePath as String)
        
        
        if contactDB.open()
        {
            print("NAme", (name.text)!)
            
            
            let insertQuery = "INSERT INTO CONTACTS(NAME,ADDRESS,PHONE) VALUES('\((name.text)!)','\((address.text)!)','\((phoneNo.text)!)')"
            
            let result = contactDB.executeUpdate(insertQuery, withArgumentsInArray: nil)
            if !result {
                status.text = "Failed to add contact"
                print("Error: \(contactDB.lastErrorMessage())")
            } else {
                status.text = "Contact Added"
                name.text = ""
                address.text = ""
                phoneNo.text = ""
            }
        }
        else {
            print("Error: \(contactDB.lastErrorMessage())")
        }
    
    }
 
    
    @IBAction func findContact(sender: AnyObject) {
        
        
        let contactDB = FMDatabase(path: databasePath as String)
        
        if contactDB.open() {
            let querySQL = "SELECT address, phone FROM CONTACTS WHERE name = '\((name.text)!)'"
            
            let results:FMResultSet? = contactDB.executeQuery(querySQL,
                withArgumentsInArray: nil)
            
            if results?.next() == true {
                let addressS : String =  (results?.stringForColumn("address"))!
                let phoneS : String =  (results?.stringForColumn("phone"))!
                address.text = addressS
                phoneNo.text = phoneS
                //address.text = results?.stringForColumn("address")
                //phoneNo.text = results?.stringForColumn("phone")
                status.text = "Record Found"
            } else {
                status.text = "Record not found"
                address.text = ""
                phoneNo.text = ""
            }
            contactDB.close()
        } else {
            print("Error: \(contactDB.lastErrorMessage())")
        }
    }
    

    
    @IBAction func deleteContact(sender: AnyObject) {
        
        
        
        let contactDB = FMDatabase(path: databasePath as String)
        
        if contactDB.open() {
            let deleteQuerySQL = "DELETE  FROM CONTACTS WHERE name = '\((name.text)!)'"
            
            let result = contactDB.executeUpdate(deleteQuerySQL, withArgumentsInArray: nil)
            
            //let result = contactDB.executeQuery(deleteQuerySQL, withArgumentsInArray: nil)

            if !result {
                status.text = "Failed to Delete contact"
                print("Error: \(contactDB.lastErrorMessage())")
            } else {
                status.text = "Contact deleted"
                name.text = ""
                address.text = ""
                phoneNo.text = ""
            }
            contactDB.close()
        } else {
            print("Error: \(contactDB.lastErrorMessage())")
        }

    }
    
    // CHnages
    
//    class func getPath(fileName: String) -> String {
//        let documentsURL = NSFileManager.defaultManager().URLsForDirectory(.DocumentDirectory, inDomains: .UserDomainMask)[0]
//        let fileURL = documentsURL.URLByAppendingPathComponent(fileName)
//        return fileURL.path!
//    }
//   
//    
//    
//    class func copyFile(fileName: NSString) {
//        let dbPath: String = getPath(fileName as String)
//        let fileManager = NSFileManager.defaultManager()
//        if !fileManager.fileExistsAtPath(dbPath) {
//            let documentsURL = NSBundle.mainBundle().resourceURL
//            let fromPath = documentsURL!.URLByAppendingPathComponent(fileName as String)
//            var error : NSError?
//            do {
//                try fileManager.copyItemAtPath(fromPath.path!, toPath: dbPath)
//            } catch let error1 as NSError {
//                error = error1
//            }
//            let alert: UIAlertView = UIAlertView()
//            if (error != nil) {
//                alert.title = "Error Occured"
//                alert.message = error?.localizedDescription
//            } else {
//                alert.title = "Successfully Copy"
//                alert.message = "Your database copy successfully"
//            }
//            alert.delegate = nil
//            alert.addButtonWithTitle("Ok")
//            alert.show()
//        }
//    }
   // ENd

}

