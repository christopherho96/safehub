//
//  ViewController.swift
//  SafeHub
//
//  Created by Christopher Ho on 2018-01-27.
//  Copyright © 2018 chovo. All rights reserved.
//

import UIKit
import Firebase

class ViewController: UIViewController {
    
    
    @IBOutlet weak var userName: UITextField!
    @IBOutlet weak var userPassword: UITextField!
    
    @IBAction func tappedLoginButton(_ sender: Any) {
        Auth.auth().signIn(withEmail: userName.text!, password: userPassword.text!) { (user, error) in
            if error != nil{
                print(error!)
            }else{
                print("succesfully logged in")
                print(user!)
                self.performSegue(withIdentifier: "segueToHomePage", sender: self)
            }
        }
    }
    
    @IBOutlet weak var tappedSignUpButton: UIButton!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }


}

