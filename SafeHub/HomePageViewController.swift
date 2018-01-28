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

class HomePageViewController: UIViewController {
    
    let audioEngine = AVAudioEngine()
    let speechRecognizer: SFSpeechRecognizer? = SFSpeechRecognizer()
    let request = SFSpeechAudioBufferRecognitionRequest()
    var recognitionTask: SFSpeechRecognitionTask?

    @IBOutlet weak var isPasswordCorrectLabel: UILabel!
    @IBOutlet weak var detailedTextLabel: UILabel!
    @IBAction func tappedVoiceRecognition(_ sender: Any) {
        self.recordAndRecognizeSpeech()
        //performSegue(withIdentifier:         "segueToVoiceRecognition", sender: self)
    }
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
        // Dispose of any resources that can be recreated.
    }

    @IBAction func tappedLogOut(_ sender: Any) {
        do{
            try Auth.auth().signOut()
            self.performSegue(withIdentifier: "segueToLoginPage", sender: self)
            print("succesfully logged out")
        }catch{
            print("error, there was a problem signing out")
        }
    }
    @IBAction func tappedFingerPrintRecognition(_ sender: Any) {
        authenticateUser()
    }
    
    
    func recordAndRecognizeSpeech(){
        
        //audioEngine uses what are called nodes to process bits of audio
        
        let node = audioEngine.inputNode
        let recordingFormat = node.outputFormat(forBus: 0)
        node.installTap(onBus: 0, bufferSize: 1024, format: recordingFormat) { (buffer, _) in
            self.request.append(buffer)
        }
        audioEngine.prepare()
        do{
            try audioEngine.start()
        }catch{
            return print("this is the error: \(error)")
        }
        
        guard let myRecognizer = SFSpeechRecognizer() else {
            // a recognizer is not supported
            return
        }
        
        if !myRecognizer.isAvailable {
            // a recognizer is not available
            return
        }
        
        recognitionTask = speechRecognizer?.recognitionTask(with: request, resultHandler: { (result, error) in
            if let result = result{
                let bestString = result.bestTranscription.formattedString
                self.detailedTextLabel.text = bestString
                
                var lastString: String = ""
                for segment in result.bestTranscription.segments{
                    let indexTo = bestString.index(bestString.startIndex, offsetBy: segment.substringRange.location)
                    lastString = bestString.substring(from: indexTo)
                    
                    let usersDB = Database.database().reference().child("Users")
                    usersDB.observe(.childAdded) { (snapshot) in
                        let snapshotValue = snapshot.value as! Dictionary<String,String>
                        
                        guard let text = snapshotValue["recordedPassword"] else {return}
                        if bestString == text {
                            self.isPasswordCorrectLabel.text = "Correct Password!"
                            print("stopped recording")
                            self.audioEngine.stop()
                            self.audioEngine.inputNode.removeTap(onBus: 0)
                            self.request.endAudio()
                            self.recognitionTask?.cancel()
                            self.recognitionTask = nil
                            
                            
                            
                            
                            usersDB.queryOrderedByKey()
                            //usersDB.child().setValue(["passwordMatch":"true"])
                        
                            //usersDB.childByAutoId().child("passwordMatch").setValue("true")
                        
                        
                        }else{
                            self.isPasswordCorrectLabel.text = "Wrong Password"
                        }
                        
                    //create new child called text in database
//                    let speechDB = Database.database().reference().child("text")
//                    let speechDictionary = ["Sender": Auth.auth().currentUser?.email, "text": lastString]
//                    speechDB.childByAutoId().setValue(speechDictionary)
                }
               // self.checkForColorsSaid(resultString: lastString)
                
                }
            }else if let error = error{
                print(error)
            }
        })
    }
    
    func authenticateUser() {
        let context = LAContext()
        var error: NSError?
        
        if context.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: &error) {
            let reason = "Identify yourself!"
            
            context.evaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, localizedReason: reason) {
                [unowned self] success, authenticationError in
                
                DispatchQueue.main.async {
                    if success {
                        //self.runSecretCode()
                        print("Success scanning fingerprint")
                    } else {
                        let ac = UIAlertController(title: "Authentication failed", message: "Sorry!", preferredStyle: .alert)
                        ac.addAction(UIAlertAction(title: "OK", style: .default))
                        self.present(ac, animated: true)
                    }
                }
            }
        } else {
            let ac = UIAlertController(title: "Touch ID not available", message: "Your device is not configured for Touch ID.", preferredStyle: .alert)
            ac.addAction(UIAlertAction(title: "OK", style: .default))
            present(ac, animated: true)
        }
    }

    

}
