//
//  voiceRecognitionViewController.swift
//  SafeHub
//
//  Created by Christopher Ho on 2018-01-27.
//  Copyright © 2018 chovo. All rights reserved.
//

import UIKit
import Speech
import Firebase
import FirebaseDatabase

class voiceRecognitionViewController: UIViewController {
    
    //process audio streams, gives update when mic recieves audio
    let audioEngine = AVAudioEngine()
    //does actual speech recognition of words
    //by default will recognize language to default location
    let speechRecognizer: SFSpeechRecognizer? = SFSpeechRecognizer()
    //allocates speech in real time and controls buffering
    let request = SFSpeechAudioBufferRecognitionRequest()
    //used to manage recording such as pause stop
    var recognitionTask: SFSpeechRecognitionTask?

    @IBOutlet weak var colorView: UIView!
    
    @IBAction func tappedStartButton(_ sender: Any) {
        self.recordAndRecognizeSpeech()
    }
    
    @IBAction func tappedStopButton(_ sender: Any) {
        print("stopped recording")
        audioEngine.stop()
        audioEngine.inputNode.removeTap(onBus: 0)
        request.endAudio()
        recognitionTask?.cancel()
        recognitionTask = nil
    }
    @IBOutlet weak var detectedTextLabel: UILabel!
    
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
                let bestString = result.bestTranscription.formattedString
                self.detectedTextLabel.text = bestString
                
                var lastString: String = ""
                for segment in result.bestTranscription.segments{
                    let indexTo = bestString.index(bestString.startIndex, offsetBy: segment.substringRange.location)
                    lastString = bestString.substring(from: indexTo)
                    //create new child called text in database
                    let speechDB = Database.database().reference().child("text")
                    let speechDictionary = ["Sender": Auth.auth().currentUser?.email, "text": lastString]
                    speechDB.childByAutoId().setValue(speechDictionary)
                }
                self.checkForColorsSaid(resultString: lastString)
                
            }else if let error = error{
                print(error)
            }
        })
    }
    
    func checkForColorsSaid(resultString: String){
        switch resultString {
        case "red":
            colorView.backgroundColor = UIColor.red
        default:
            break
        }
    }
}
