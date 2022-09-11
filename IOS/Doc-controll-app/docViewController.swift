//
//  docViewController.swift
//  Doc-controll-app
//
//  Created by RAPHAEL LAM CHEW RAY stu on 10/9/22.
//

import UIKit
import Firebase
import FirebaseStorage
import FirebaseAuth
import GoogleSignIn
import FirebaseFirestore

class docViewController: UIViewController, ScreenRecordDelegate {
    
    func screen(_ screen: UIScreen, didRecordStarted isRecording: Bool) {
        print("recording started, Recording")
        self.view.backgroundColor = UIColor(white: 1, alpha: 1)
        let Recordingalert = UIAlertController(title: "Stop screenrecording", message: "Screen recording is not allowed on this app", preferredStyle: .alert)
        Recordingalert.addAction(UIAlertAction(title: NSLocalizedString("OK", comment: "Default action"), style: .default, handler: { _ in
        NSLog("The \"OK\" alert occured.")
        }))
        self.present(Recordingalert, animated: true, completion: nil)
    }

    func screen(_ screen: UIScreen, didRecordEnded isRecording: Bool) {
        self.view.backgroundColor = UIColor(white: 1, alpha: 0)
        print("recording ended, Recording")
    }
    
    //outlets
    @IBOutlet weak var imageView: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // screenshot protection
        ScreenGuardManager.shared.screenRecordDelegate = self
        ScreenGuardManager.shared.listenForScreenRecord()
        ScreenGuardManager.shared.guardScreenshot(for: self.view)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        getImage()
    }
    
    //getting the image
    func getImage() {
        
        // check if empty
        if DOCID != "" {
        
            let storage = Storage.storage()

            let storageRef = storage.reference()

            let islandRef = storageRef.child(DOCID)
            islandRef.getData(maxSize: 10 * 1024 * 1024) { [self] data, error in
                if let error = error {
                    // Uh-oh, an error occurred!
                    print(error)
                    let alert = UIAlertController(title: "File not found", message: "There is either no file or an error occured", preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: NSLocalizedString("OK", comment: "Default action"), style: .default, handler: { _ in
                    NSLog("The \"OK\" alert occured.")
                    }))
                    self.present(alert, animated: true, completion: nil)
                } else {
                    // Data for "images/island.jpg" is returned
                    let image = UIImage(data: data!)
                    print("image downloaded")
                    self.imageView.image = image
                    viewWillAppear(true)
                }
            }
        } else {
            let alert = UIAlertController(title: "File not found", message: "There is either no file or an error occured", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: NSLocalizedString("OK", comment: "Default action"), style: .default, handler: { _ in
            NSLog("The \"OK\" alert occured.")
            }))
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
