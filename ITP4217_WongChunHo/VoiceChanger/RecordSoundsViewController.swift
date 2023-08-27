
import UIKit
import AVFoundation
import SwiftUI


struct MyStoryboardVCRepresented : UIViewControllerRepresentable {
    func makeUIViewController(context: Context) -> RecordSoundsViewController {
        UIStoryboard(name: "Main", bundle: Bundle.main).instantiateViewController(identifier: "RecordSoundsViewController") as! RecordSoundsViewController //theoretically unsafe to unwrap like this with `!`, but we know it works, since the view controller is included in the storyboard
    }
    
    func updateUIViewController(_ uiViewController: RecordSoundsViewController, context: Context) {
    }
}


protocol AudioRecorder {
    var audioRecorder: AVAudioRecorder! { get }
}

class RecordSoundsViewController: UIViewController, AVAudioRecorderDelegate, AudioRecorder {

    // UI Buttons
    @IBOutlet weak var recordingLabel: UILabel!
    @IBOutlet weak var recordButton: UIButton!
    @IBOutlet weak var stopRecordingButton: UIButton!
    
    
    // Instances
    var audioRecorder: AVAudioRecorder!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // see if app store review should try to present
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        // make sure that the stop button is not enabled when the view is about to appear
        stopRecordingButton.isEnabled = false
    }

    // Action after Record button is pressed
    @IBAction func recordAudio(_ sender: Any) {
        recordSession()
     }

    // action after stop recording button is pressed
    @IBAction func stopRecordingAudioButton(_ sender: Any) {
        setRecordingSessionLabelsAndButtons()
        audioRecorder.stop()
        let audioSession = AVAudioSession.sharedInstance()
        do {
            try audioSession.setActive(false)
        } catch {
        showAlert(Alerts.RecordingFailedTitle, message: Alerts.RecordingDisabledMessage)
        }
    }
    
    // MARK: Record audio
    func recordSession() {
        let dirPath = NSSearchPathForDirectoriesInDomains(.documentDirectory,.userDomainMask, true)[0] as String
        let recordingName = "recordedVoice.wav"
        let pathArray = [dirPath, recordingName]
        let filePath = URL(string: pathArray.joined(separator: "/"))
        let session = AVAudioSession.sharedInstance()
        session.requestRecordPermission() { allowed in
            DispatchQueue.main.async {
                if allowed {
                    do {
                        try session.setCategory(AVAudioSession.Category.playAndRecord, options:AVAudioSession.CategoryOptions.defaultToSpeaker)
                        try self.audioRecorder = AVAudioRecorder(url: filePath!, settings: [:])
                        self.setRecordingSessionLabelsAndButtons()
                        self.audioRecorder.delegate = self
                        self.audioRecorder.isMeteringEnabled = true
                        self.audioRecorder.prepareToRecord()
                        self.audioRecorder.record()
                    } catch {
                        self.showAlert(Alerts.AudioSessionError, message: String(describing: Error.self))
                    }
                } else {
                    self.showAlert(Alerts.RecordingDisabledTitle, message: Alerts.RecordingDisabledMessage)
                }
            }
        }
    }
    
    // Checks status of buttons and lables and sets the correctly
    func setRecordingSessionLabelsAndButtons() {
        stopRecordingButton.isEnabled = stopRecordingButton.isEnabled ? false : true
        recordButton.isEnabled = recordButton.isEnabled ? false : true
    }
    
    func audioRecorderDidFinishRecording(_ recorder: AVAudioRecorder, successfully flag: Bool) {
        if flag {
            performSegue(withIdentifier: "stopRecordingSegue", sender: audioRecorder.url)
        } else {
            showAlert(Alerts.AudioSessionError, message: String(describing: Error.self))
        }
    }
    
    // Gets ready to send recording over to playSoundsViewController
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "stopRecordingSegue" {
            let playSoundsVC = segue.destination as! PlaySoundsViewController
            let recordedAudioURL = sender as! URL
            playSoundsVC.recordedAudioURL = recordedAudioURL
        }
    }
    
}

