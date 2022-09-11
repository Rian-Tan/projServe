//
//  ViewController.swift
//  Doc-controll-app
//
//  Created by RAPHAEL LAM CHEW RAY stu on 8/9/22.
//

import UIKit
import WebKit
import Firebase
import FirebaseStorage
import FirebaseAuth
import GoogleSignIn
import FirebaseFirestore

public var files: Array<String> = []
public var email: String = ""
public var dataDict: Dictionary<String, Any> = [:]

class ViewController: UIViewController {
    let db = Firestore.firestore()

    //outlets
    @IBOutlet weak var signInButton: UIButton!
    
    //actions
    @IBAction func googleSignInPressed(_ sender: Any) {
        login()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //button
        signInButton.layer.cornerRadius = 15
        
        //change background
        self.view.backgroundColor = UIColor(patternImage: UIImage(named: "background.png")!)
    }
    
    // sign out each time view appears
    override func viewDidAppear(_ animated: Bool) {
        let firebaseAuth = Auth.auth()
        
        do {
            try firebaseAuth.signOut()
        } catch let signOutError as NSError {
            print("Error signing out: %@", signOutError)
        }
    }
    
    // read the func name
    func getRootViewController() -> UIViewController {
        guard let screen = UIApplication.shared.connectedScenes.first as? UIWindowScene else {
            return .init()
        }
        
        guard let root = screen.windows.first?.rootViewController else {
            return .init()
        }
        
        return root
    }
    
    //read the func name
    func login() {
        
        guard let clientID = FirebaseApp.app()?.options.clientID else { return }

        // Create Google Sign In configuration object.
        let config = GIDConfiguration(clientID: clientID)
        
        GIDSignIn.sharedInstance.signIn(with: config, presenting: getRootViewController()) {
            [self] user, err in
            
            
            if let error = err {
                print(error.localizedDescription)
                return
            }
            
            guard let authentication = user?.authentication, let idToken = authentication.idToken
            else { return }
            
            let credential = GoogleAuthProvider.credential(withIDToken: idToken, accessToken: authentication.accessToken)
            
            Auth.auth().signIn(with: credential) { result, error in
                
                if let err = error {
                    print(err.localizedDescription)
                    return
                }
                
                guard let user = result?.user else { return }
                // I wanna see user data
                print("user data:")
                print(user.displayName!)
                print(user.email!)
                email = user.email!
                print(user)
                print("end of user data")
                
            }
        
        // segue to next VC
        checkUser{ self.performSegue(withIdentifier: "afterLoginSegue", sender: nil) }
            
        }
        
    }
    
    // check if the user email is already in the database
    func checkUser(completion: @escaping () -> Void) {
        var x: Bool = false
        
        db.collection("test").getDocuments() { [self] (querySnapshot, err) in
            if let err = err {
                print("Error getting documents: \(err)")
            } else {
                for document in querySnapshot!.documents {
                    print("\(document.documentID) => \(document.data())")
                    if document.documentID == email {
                        print("in database")
                        //take the document data for the user
                        dataDict = document.data()
                        x = true
                    }
                }
                
                // if not in database add them to database
                if x == false {
                    db.collection("test").document(email).setData(["1":"", "2":"", "3":"", "4":"", "5":"", "6":"", "7":"", "8":""]) { err in
                        if let err = err {
                            print("Error writing document: \(err)")
                        } else {
                            print("Document successfully written!")
                        }
                    }
                //new acc so will have no documents
                }
            }
            completion()
        }
        
    }
    
    
}
