//
//  SignUpViewController.swift
//  SafeHub
//
//  Created by Christopher Ho on 2018-01-27.
//  Copyright © 2018 chovo. All rights reserved.
//

import UIKit
import Firebase
import Speech

class SignUpViewController: UIViewController {

    @IBOutlet weak var userEmail: UITextField!
    //process audio streams, gives update when mic recieves audio
    let audioEngine = AVAudioEngine()
    //does actual speech recognition of words
    //by default will recognize language to default location
    let speechRecognizer: SFSpeechRecognizer? = SFSpeechRecognizer()
    //allocates speech in real time and controls buffering
    let request = SFSpeechAudioBufferRecognitionRequest()
    //used to manage recording such as pause stop
    var recognitionTask: SFSpeechRecognitionTask?
    
    var bestString = ""
    
    @IBOutlet weak var userPassword: UITextField!
    @IBAction func tappedRecordPassword(_ sender: Any) {
        self.recordAndRecognizeSpeech()
    }
    
    @IBAction func tappedStopRecord(_ sender: Any) {
        print("stopped recording")
        audioEngine.stop()
        audioEngine.inputNode.removeTap(onBus: 0)
        request.endAudio()
        recognitionTask?.cancel()
        recognitionTask = nil
    }
    
    @IBOutlet weak var detectedTextLabel: UILabel!
    
    @IBAction func tappedRegisterButton(_ sender: Any) {
        
        //use firebaseauth system
        Auth.auth().createUser(withEmail: userEmail.text!, password: userPassword.text!) { (user, error) in
            if error != nil{
                
                print(error!)
            }else{
                let speechDB = Database.database().reference().child("Users").child((Auth.auth().currentUser?.uid)!)
                let speechDictionary = ["user": Auth.auth().currentUser?.email, "recordedPassword": self.bestString, "uid": Auth.auth().currentUser?.uid, "motorID" : "1", "passwordMatch" : "false", "needToLock":"false" ]
                speechDB.setValue(speechDictionary)
                print("succesfully logged in")
                print(user!)
                self.performSegue(withIdentifier: "segueToHomePage", sender: nil)
            }
        }
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
                self.bestString = result.bestTranscription.formattedString
                self.detectedTextLabel.text = self.bestString
                
                var lastString: String = ""
                for segment in result.bestTranscription.segments{
                    let indexTo = self.bestString.index(self.bestString.startIndex, offsetBy: segment.substringRange.location)
                    lastString = self.bestString.substring(from: indexTo)
                    //create new child called text in database

                }
                //self.checkForColorsSaid(resultString: lastString)
                
            }else if let error = error{
                print(error)
            }
        })
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }

}
