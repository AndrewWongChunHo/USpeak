//
//  ViewController.swift
//  arvoice
//
//  Created by Croquettebb on 25/4/2023.
//

import UIKit
import RealityKit
import ARKit
import Speech
import SwiftUI


struct ARVCRepresented : UIViewControllerRepresentable {
    func makeUIViewController(context: Context) -> ViewController {
        UIStoryboard(name: "ARSTory", bundle: Bundle.main).instantiateViewController(identifier: "arView") as! ViewController 
    }
    
    func updateUIViewController(_ uiViewController: ViewController, context: Context) {
    }
}

class ViewController: UIViewController {
    
    @IBOutlet var arView: ARView!
    var robotEntity: Entity?
    
    var moveToLocation: Transform = Transform()
    
    var moveDuration: Double = 5 //seconds
    
    //Speech Recognition
    let speechRecognizer : SFSpeechRecognizer? = SFSpeechRecognizer()
    let speechRequest = SFSpeechAudioBufferRecognitionRequest()
    var speechTask = SFSpeechRecognitionTask()
    
    //Audio
    let audioEngine = AVAudioEngine()
    let audioSession = AVAudioSession.sharedInstance()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Start and initialize
        startARSession()
        
        //Load 3d model
        robotEntity = try! Entity.load(named: "drummer")
        
        //Tap Detector
        arView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleTap(recognizer:))))
        
        //Start Speech Recognition
        startSpeechRecognition()
    }
    
    @objc func handleTap(recognizer: UITapGestureRecognizer) {
        let tapLocation = recognizer.location(in: arView)
        let results = arView.raycast(from: tapLocation, allowing: .estimatedPlane, alignment: .horizontal)
        
        if let firstResult = results.first{
            let worldPos = simd_make_float3(firstResult.worldTransform.columns.3)
            
            placeObject(object: robotEntity!, position: worldPos)
            
            move(direction: "forward")
            
        }
        
    }
    
    func startARSession() {
        arView.automaticallyConfigureSession = true
        
        //Plane Detection
        let configuration = ARWorldTrackingConfiguration()
        configuration.planeDetection = [.horizontal]
        configuration.environmentTexturing = .automatic
        
//        arView.debugOptions = .showAnchorGeometry
        arView.session.run(configuration)
    }
    
    func placeObject(object: Entity, position: SIMD3<Float>) {
        
        let objectAnchor = AnchorEntity(world: position)
        
        objectAnchor.addChild(object)
        
        arView.scene.addAnchor(objectAnchor)
        
    }
    
    func move(direction: String) {
        switch direction {
        case "forward":
            moveToLocation.translation = (robotEntity?.transform.translation)! + simd_float3 (x: 0, y: 0, z: 20)
            robotEntity?.move(to: moveToLocation, relativeTo: robotEntity, duration: moveDuration)
            
            walkAnimation(moveDuration: moveDuration)
            
        case "back":
            moveToLocation.translation = (robotEntity?.transform.translation)! + simd_float3 (x: 0, y: 0, z: -20)
            robotEntity?.move(to: moveToLocation, relativeTo: robotEntity, duration: moveDuration)
            
            walkAnimation(moveDuration: moveDuration)
        case "left":
            let rotateToAngle = simd_quatf(angle: GLKMathDegreesToRadians(90), axis: SIMD3(x:0, y:1, z:0))
            robotEntity?.setOrientation(rotateToAngle, relativeTo: robotEntity)
        case "right":
            let rotateToAngle = simd_quatf(angle: GLKMathDegreesToRadians(-90), axis: SIMD3(x:0, y:1, z:0))
            robotEntity?.setOrientation(rotateToAngle, relativeTo: robotEntity)
        case "circle":
            let rotateToAngle = simd_quatf(angle: GLKMathDegreesToRadians(-180), axis: SIMD3(x:0, y:1, z:0))
            robotEntity?.setOrientation(rotateToAngle, relativeTo: robotEntity)
        default:
            print("No movement commands")
        }
    }
    
    func walkAnimation (moveDuration: Double) {
        
        if let robotAnimation = robotEntity?.availableAnimations.first {
            robotEntity?.playAnimation(robotAnimation.repeat(duration: moveDuration), transitionDuration: 0.5, startsPaused: false)
        } else {
            print("No Animation presented in USDZ animation")
        }
        
    }
    
    func startSpeechRecognition() {
        
        //1. Permission
        requestPermission()
        
        //2. Audio Record
        startAudioRecording()
        
        //3. Speech Recognition
        SpeechRecognize()
    }
    
    func requestPermission() {
        SFSpeechRecognizer.requestAuthorization { (authorizationStatus) in
            if(authorizationStatus == .authorized){
                print("Authorized")
            } else if (authorizationStatus == .denied) {
                print("Denied")
            } else if (authorizationStatus == .notDetermined){
                print("Waiting")
            } else if authorizationStatus == .restricted {
                print("Speech Recognition not available")
            }
            
        }
        
    }
    
    func startAudioRecording() {
        
        //Input node
        let node = audioEngine.inputNode
        let recordingFormat = node.outputFormat(forBus: 0)
        
        node.installTap(onBus: 0, bufferSize: 1024, format: recordingFormat) { (buffer, _) in
            
            //Pass the audio samples to Speech Recognition
            self.speechRequest.append(buffer)
            
        }
        
        //Audio Engine start
        do {
            try audioSession.setCategory(.record, mode: .measurement, options: .duckOthers)
            try audioSession.setActive(true, options: .notifyOthersOnDeactivation)
            
            audioEngine.prepare()
            try audioEngine.start()
        }
        catch {
            
        }
   
    }
    
    func SpeechRecognize() {
        
        //Check availability
        guard let speechRecognizer = SFSpeechRecognizer() else {
            print("Speech recognizer not available")
            return
        }
        
        if (speechRecognizer.isAvailable == false) {
            print("Temporaily not working")
        }
        
        //Task (recognized text)
        var count = 0
        speechTask = speechRecognizer.recognitionTask(with: speechRequest, resultHandler: { (result, error) in
            count = count + 1
            if (count == 1) {
                //get last word spoken
                guard let result = result else {return}
                let recognizedText = result.bestTranscription.segments.last
                
                //robot move
                self.move(direction: recognizedText!.substring)
                
            } else if (count >= 3) {
                count = 0
            }

        })
        
    }
}
