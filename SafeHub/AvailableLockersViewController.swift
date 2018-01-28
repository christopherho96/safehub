//
//  AvailableLockersViewController.swift
//  SafeHub
//
//  Created by Christopher Ho on 2018-01-28.
//  Copyright © 2018 chovo. All rights reserved.
//

import UIKit
import Firebase
//
//struct locker{
//    let lockerName : String!
//    let lockerAvailable : String!
//}

var lockers : [Locker] = []


class AvailableLockersViewController: UIViewController,  UITableViewDelegate, UITableViewDataSource {
    
    var itemDataToSendToDetailedView = Locker()
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return lockers.count
    }
    
    var key = Auth.auth().currentUser?.uid
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! TableViewCell
        
        cell.lockerTitle.text = lockers[indexPath.row].lockerNumber
        
        //is avaiable
        if lockers[indexPath.row].lockerAvailable == "false" {
            cell.lockerAvailability.text = "Available"

            
            //is not available
        }else{
            if lockers[indexPath.row].assignedTo == key{
                cell.lockerAvailability.text = "Reserved For Me"
                cell.backgroundColor = UIColor(hex: "FCD667")
            }else{
            cell.lockerAvailability.text = "Reserved for someone else"
            cell.isUserInteractionEnabled = false
            cell.backgroundColor = UIColor(hex: "ED4D69")
            }
        }
        
        return cell
    }
    
    //var lockers: [Locker] = []
    
    var count = 1
    

    @IBOutlet weak var lockerTableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        lockerTableView.delegate = self
        lockerTableView.dataSource = self
        lockerTableView.estimatedRowHeight = lockerTableView.rowHeight
        lockerTableView.rowHeight = UITableViewAutomaticDimension
        lockerTableView.register(UINib(nibName: "TableViewCell", bundle: nil), forCellReuseIdentifier: "cell")
        lockerTableView.backgroundColor = UIColor(hex: "21B7C8")
    

        // Do any additional setup after loading the view.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        lockerTableView.reloadData()

    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("This cell from the chat list was selected: \(indexPath.row)")
        itemDataToSendToDetailedView = lockers[indexPath.row]
        tableView.deselectRow(at: indexPath, animated: true)
        
        performSegue(withIdentifier: "segueToDetailedLockerView", sender: self)
    }

    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "segueToDetailedLockerView" {
            
            let secondVC = segue.destination as! DetailedLockerViewController
            secondVC.recievedData = itemDataToSendToDetailedView
            
        }
    }
}

extension UIColor {
    convenience init(hex: String) {
        let scanner = Scanner(string: hex)
        scanner.scanLocation = 0
        
        var rgbValue: UInt64 = 0
        
        scanner.scanHexInt64(&rgbValue)
        
        let r = (rgbValue & 0xff0000) >> 16
        let g = (rgbValue & 0xff00) >> 8
        let b = rgbValue & 0xff
        
        self.init(
            red: CGFloat(r) / 0xff,
            green: CGFloat(g) / 0xff,
            blue: CGFloat(b) / 0xff, alpha: 1
        )
    }
}

