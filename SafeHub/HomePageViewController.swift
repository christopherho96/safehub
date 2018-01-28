//
//  HomePageViewController.swift
//  SafeHub
//
//  Created by Christopher Ho on 2018-01-27.
//  Copyright © 2018 chovo. All rights reserved.
//

import UIKit
import Firebase
import Speech
import LocalAuthentication
import MapKit
import CoreLocation

class HomePageViewController: UIViewController, MKMapViewDelegate, CLLocationManagerDelegate  {
    
    @IBOutlet weak var Map: MKMapView!
    
    @IBOutlet weak var userName: UILabel!
    @IBOutlet weak var detailView: UIView!
    @IBOutlet weak var verifyMethodsLabel: UILabel!
    
    @IBOutlet weak var uidLabel: UILabel!
    @IBOutlet weak var currentLocks: UILabel!
    var count = 1
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        
        self.navigationController?.navigationBar.tintColor = UIColor.white
        
        Map.delegate = self
        detailView.layer.masksToBounds = true
        detailView.layer.cornerRadius = CGFloat(5)
        
        userName.text = "Welcome " + (Auth.auth().currentUser?.email!)!
        uidLabel.text = "UID: " + (Auth.auth().currentUser?.uid)!
        
        
        let location = CLLocationCoordinate2DMake(43.6532, 79.3832)
        
        //this span controls how zoomed in the view is
        let span = MKCoordinateSpanMake(0.01, 0.01)
        
        let region = MKCoordinateRegion(center: location, span: span)
        
        Map.setRegion(region, animated: true)
        
        
        let annotation = MKPointAnnotation()
        annotation.coordinate = location
        annotation.title = "Test"
        annotation.subtitle = "TEST"
        Map.addAnnotation(annotation)
        
        let lockersDB = Database.database().reference()
        lockersDB.child("Lockers").queryOrderedByKey().observe(.childAdded, with: { (snapshot) in
            if let dict = snapshot.value as? NSDictionary, let postContent = dict["isTaken"] as? String {
                
                let locker = Locker()
                locker.lockerNumber = "locker\(self.count)"
                locker.lockerAvailable = postContent
                locker.assignedTo = (dict["takenBy"] as? String)!
                lockers.append(locker)
                self.count = self.count + 1
                
            } else {
                print("")
            }
        })

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
        // Dispose of any resources that can be recreated.
    }

//    @IBAction func tappedLogOut(_ sender: Any) {
//        do{
//            try Auth.auth().signOut()
//            self.performSegue(withIdentifier: "segueToLoginPage", sender: self)
//            print("succesfully logged out")
//        }catch{
//            print("error, there was a problem signing out")
//        }
//    }

}
