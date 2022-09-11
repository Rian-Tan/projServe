//
//  homeViewController.swift
//  Doc-controll-app
//
//  Created by RAPHAEL LAM CHEW RAY stu on 9/9/22.
//

import UIKit
import Firebase
import GoogleSignIn
import FirebaseFirestore

public var DOCID: String = ""

class homeViewController: UIViewController {
    let db = Firestore.firestore()

    //outlets
    @IBOutlet weak var Doc1: UIButton!
    @IBOutlet weak var Doc2: UIButton!
    @IBOutlet weak var Doc3: UIButton!
    @IBOutlet weak var Doc4: UIButton!
    @IBOutlet weak var Doc5: UIButton!
    @IBOutlet weak var Doc6: UIButton!
    @IBOutlet weak var Doc7: UIButton!
    @IBOutlet weak var Doc8: UIButton!
    @IBOutlet weak var opacityView: UIView!
    
    //functions
    @IBAction func doc1press(_ sender: Any) {
        let temp = String(describing: dataDict["1"]!)
        DOCID = "documents/" + temp
        performSegue(withIdentifier: "showDoc", sender: nil)
    }
    
    @IBAction func doc2press(_ sender: Any) {
        let temp = String(describing: dataDict["2"]!)
        DOCID = "documents/" + temp
        performSegue(withIdentifier: "showDoc", sender: nil)
    }
    
    @IBAction func doc3press(_ sender: Any) {
        let temp = String(describing: dataDict["3"]!)
        DOCID = "documents/" + temp
        performSegue(withIdentifier: "showDoc", sender: nil)
    }
    
    @IBAction func doc4press(_ sender: Any) {
        let temp = String(describing: dataDict["4"]!)
        DOCID = "documents/" + temp
        performSegue(withIdentifier: "showDoc", sender: nil)
    }
    
    @IBAction func doc5press(_ sender: Any) {
        let temp = String(describing: dataDict["5"]!)
        DOCID = "documents/" + temp
        performSegue(withIdentifier: "showDoc", sender: nil)
    }
    
    @IBAction func doc6press(_ sender: Any) {
        let temp = String(describing: dataDict["6"]!)
        DOCID = "documents/" + temp
        performSegue(withIdentifier: "showDoc", sender: nil)
    }
    
    @IBAction func doc7press(_ sender: Any) {
        let temp = String(describing: dataDict["7"]!)
        DOCID = "documents/" + temp
        performSegue(withIdentifier: "showDoc", sender: nil)
    }
    
    @IBAction func doc8press(_ sender: Any) {
        let temp = String(describing: dataDict["8"]!)
        DOCID = "documents/" + temp
        performSegue(withIdentifier: "showDoc", sender: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        Doc1.layer.cornerRadius = 20
        Doc2.layer.cornerRadius = 20
        Doc3.layer.cornerRadius = 20
        Doc4.layer.cornerRadius = 20
        Doc5.layer.cornerRadius = 20
        Doc6.layer.cornerRadius = 20
        Doc7.layer.cornerRadius = 20
        Doc8.layer.cornerRadius = 20
        
        opacityView.backgroundColor = UIColor(white: 1, alpha: 0.2)
        self.view.backgroundColor = UIColor(patternImage: UIImage(named: "background2.jpeg")!)
    }
    
    override func viewDidAppear(_ animated: Bool) {
//        print(email)
//        print("User data: \(dataDict)")
//        print("link one: \(dataDict["1"]!)")
//        print("link two: \(dataDict["2"]!)")
//        print("link three: \(dataDict["3"]!)")
//        print("link four: \(dataDict["4"]!)")
//        print("link five: \(dataDict["5"]!)")
//        print("link six: \(dataDict["6"]!)")
//        print("link seven: \(dataDict["7"]!)")
//        print("link eight: \(dataDict["8"]!)")
        //collectData(email: email)
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
