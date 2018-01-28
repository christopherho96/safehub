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
    
    var count = 0

    @IBOutlet weak var lockerNumber: UILabel!

    
    @IBAction func tappedAssignLocker(_ sender: Any) {
        
        
        database.child("Users").child((Auth.auth().currentUser?.uid)!).observeSingleEvent(of: .value) { (snapshot) in
            if let dict = snapshot.value as? NSDictionary{
                let string = dict["motorID"] as? String
                print(string!)
                
                if self.recievedData.lockerNumber == "locker1" {
                    self.database.child("Users").child(self.key!).updateChildValues(["motorID": "1"])
                    self.database.child("Lockers").child("locker1").updateChildValues(["takenBy": self.key!])
                }else if(self.recievedData.lockerNumber == "locker2"){
                    self.database.child("Users").child(self.key!).updateChildValues(["motorID": "2"])
                    self.database.child("Lockers").child("locker2").updateChildValues(["takenBy": self.key!])
                }else if(self.recievedData.lockerNumber == "locker3"){
                    self.database.child("Users").child(self.key!).updateChildValues(["motorID": "3"])
                    self.database.child("Lockers").child("locker3").updateChildValues(["takenBy": self.key!])
                }else if(self.recievedData.lockerNumber == "locker4"){
                    self.database.child("Users").child(self.key!).updateChildValues(["motorID": "4"])
                    self.database.child("Lockers").child("locker4").updateChildValues(["takenBy": self.key!])
                }
                
            }
        }
  
        
        
        database.child("Lockers").queryOrderedByKey().observe(.childAdded, with: { (snapshot) in
            if let dict = snapshot.value as? NSDictionary, let postContent = dict["isTaken"] as? String{
                
                if snapshot.key == self.recievedData.lockerNumber{
                    self.database.child("Lockers").child(snapshot.key).updateChildValues(["isTaken": "true"])
                    for locker in lockers{
                        if locker.lockerNumber == snapshot.key{
                            lockers[self.count].lockerAvailable = "true"
                            lockers[self.count].assignedTo = self.key!
                        }else{
                            self.count = self.count + 1
                        }
                    }
                }
            } else {
                print("")
            }
        })
        
        self.count = 0
    }
    
    
    @IBAction func tappedUnassignLocker(_ sender: Any) {
        database.child("Users").child((Auth.auth().currentUser?.uid)!).observeSingleEvent(of: .value) { (snapshot) in
            if let dict = snapshot.value as? NSDictionary{
                let string = dict["motorID"] as? String
                print(string!)
                
                if self.recievedData.lockerNumber == "locker1" {
                    self.database.child("Users").child(self.key!).updateChildValues(["motorID": "null"])
                    self.database.child("Lockers").child("locker1").updateChildValues(["takenBy": "null"])
                }else if(self.recievedData.lockerNumber == "locker2"){
                    self.database.child("Users").child(self.key!).updateChildValues(["motorID": "null"])
                    self.database.child("Lockers").child("locker2").updateChildValues(["takenBy": "null"])
                }else if(self.recievedData.lockerNumber == "locker3"){
                    self.database.child("Users").child(self.key!).updateChildValues(["motorID": "null"])
                    self.database.child("Lockers").child("locker3").updateChildValues(["takenBy": "null"])
                }else if(self.recievedData.lockerNumber == "locker4"){
                    self.database.child("Users").child(self.key!).updateChildValues(["motorID": "null"])
                    self.database.child("Lockers").child("locker4").updateChildValues(["takenBy": "null"])
                }
                
            }
        }
        
        
        database.child("Lockers").queryOrderedByKey().observe(.childAdded, with: { (snapshot) in
            if let dict = snapshot.value as? NSDictionary, let postContent = dict["isTaken"] as? String {
                
                if snapshot.key == self.recievedData.lockerNumber{
                    self.database.child("Lockers").child(snapshot.key).updateChildValues(["isTaken": "false"])
                    for locker in lockers{
                        if locker.lockerNumber == snapshot.key{
                            lockers[self.count].lockerAvailable = "false"
                            lockers[self.count].assignedTo = "null"
                        }else{
                            self.count = self.count + 1
                        }
                    }
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
