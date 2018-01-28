//
//  DetailedLockerViewController.swift
//  SafeHub
//
//  Created by Christopher Ho on 2018-01-28.
//  Copyright © 2018 chovo. All rights reserved.
//

import UIKit
import Firebase

class DetailedLockerViewController: UIViewController {
    
    var recievedData = Locker()
    
    let database = Database.database().reference()
    let key = Auth.auth().currentUser?.uid

    @IBOutlet weak var lockerNumber: UILabel!

    
    @IBAction func tappedAssignLocker(_ sender: Any) {
        
        
        database.child("Users").child((Auth.auth().currentUser?.uid)!).observeSingleEvent(of: .value) { (snapshot) in
            if let dict = snapshot.value as? NSDictionary{
                let string = dict["motorID"] as? String
                print(string!)
                
                if self.recievedData.lockerNumber == "locker1" {
                    self.database.child("Users").child(self.key!).updateChildValues(["motorID": "1"])
                }else if(self.recievedData.lockerNumber == "locker2"){
                    self.database.child("Users").child(self.key!).updateChildValues(["motorID": "2"])
                }else if(self.recievedData.lockerNumber == "locker3"){
                    self.database.child("Users").child(self.key!).updateChildValues(["motorID": "3"])
                }else if(self.recievedData.lockerNumber == "locker4"){
                    self.database.child("Users").child(self.key!).updateChildValues(["motorID": "4"])
                }
                
            }
        }
  
        
        
        database.child("Lockers").queryOrderedByKey().observe(.childAdded, with: { (snapshot) in
            if let dict = snapshot.value as? NSDictionary, let postContent = dict["isTaken"] as? String {
                
                if snapshot.key == self.recievedData.lockerNumber{
                    self.database.child("Lockers").child(snapshot.key).updateChildValues(["isTaken": "true"])
                }
            } else {
                print("")
            }
        })
    }
    
    
    @IBAction func tappedUnassignLocker(_ sender: Any) {
        database.child("Users").child((Auth.auth().currentUser?.uid)!).observeSingleEvent(of: .value) { (snapshot) in
            if let dict = snapshot.value as? NSDictionary{
                let string = dict["motorID"] as? String
                print(string!)
                
                if self.recievedData.lockerNumber == "locker1" {
                    self.database.child("Users").child(self.key!).updateChildValues(["motorID": "null"])
                }else if(self.recievedData.lockerNumber == "locker2"){
                    self.database.child("Users").child(self.key!).updateChildValues(["motorID": "null"])
                }else if(self.recievedData.lockerNumber == "locker3"){
                    self.database.child("Users").child(self.key!).updateChildValues(["motorID": "null"])
                }else if(self.recievedData.lockerNumber == "locker4"){
                    self.database.child("Users").child(self.key!).updateChildValues(["motorID": "null"])
                }
                
            }
        }
        
        
        database.child("Lockers").queryOrderedByKey().observe(.childAdded, with: { (snapshot) in
            if let dict = snapshot.value as? NSDictionary, let postContent = dict["isTaken"] as? String {
                
                if snapshot.key == self.recievedData.lockerNumber{
                    self.database.child("Lockers").child(snapshot.key).updateChildValues(["isTaken": "false"])
                }
            } else {
                print("")
            }
        })
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        lockerNumber.text = recievedData.lockerNumber

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
