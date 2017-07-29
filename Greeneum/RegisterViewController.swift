//
//  RegisterViewController.swift
//  Greeneum
//
//  Created by Jonathan Downing on 7/11/17.
//  Copyright © 2017 Jonathan Downing. All rights reserved.
//

import UIKit
import FirebaseAuth
import NVActivityIndicatorView

class RegisterViewController: UIViewController {

    @IBOutlet weak var activityIndicator: NVActivityIndicatorView!
    @IBOutlet weak var createAccountButton: UIButton!
    @IBOutlet weak var nameField: UITextField!
    @IBOutlet weak var emailField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    @IBOutlet weak var passwordField2: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
       
    }
    @IBAction func createAccount(_ sender: Any) {
        
        guard Auth.auth().currentUser == nil else {     //User needs to be logged out to create a new account so this guards against that
            
            if Auth.auth().currentUser?.displayName == nil{     //Hopefully this will never be called
                self.alertUser(title: "Error", message: "An error occurred. Please close and reopen the app and tap the Log Out button. If the error persists please contact support.")
                return
            }

            alertUser(title: "Already logged in", message: "You are already logged in as \(Auth.auth().currentUser!.displayName!). Please log out first.")
            return
        }

        if nameField.text != "" && emailField.text != "" && passwordField.text != "" && passwordField.text == passwordField2.text{      //ensuring the fields are all filled out
            
            self.activityIndicator.color = UIColor.darkGray     //configuring activity indicator
            self.activityIndicator.startAnimating()
            self.createAccountButton.isHidden = true        //hides button because it won't be needed unless there is an error
            
            
            Auth.auth().createUser(withEmail: emailField.text!, password: passwordField.text!, completion: { user, error in     //calls Firebase create user function using email and password
                if(error != nil){
                    print(error!.localizedDescription)
                    if let errCode = AuthErrorCode(rawValue: error!._code) {        //Handles all (likely) errors
                        switch errCode{
                        case .accountExistsWithDifferentCredential:
                            self.alertUser(title: "Email in use", message: "This email address is already associated with an account. Please log in.")
                            self.emailField.text = ""
                        case .credentialAlreadyInUse:
                            self.alertUser(title: "Email in use", message: "This email address is already associated with an account. Please log in.")
                            self.emailField.text = ""
                        case .emailAlreadyInUse:
                            self.alertUser(title: "Email in use", message: "This email address is already associated with an account. Please log in.")
                            self.emailField.text = ""
                        case .invalidEmail:
                            self.alertUser(title: "Email Badly Formed", message: "This email address is not valid. Please check it and try again.")
                        case .weakPassword:
                            self.alertUser(title: "Weak Password", message: "Password must be at least 6 characters long.")
                            self.passwordField.text = ""
                            self.passwordField2.text = ""
                        default:
                            self.alertUser(title: "Unexpected Error", message: "Error: \(error!)")
                        }
                        
                        self.activityIndicator.stopAnimating()
                        self.createAccountButton.isHidden = false
                        return
                    
                    }

                }
                else{
                    print("Successfully registered account email and password")
                    
                    let changeRequest = Auth.auth().currentUser?.createProfileChangeRequest()       //updates account name
                    changeRequest?.displayName = self.nameField.text
                    changeRequest?.commitChanges { (error) in
                        if(error != nil){
                            print(error!.localizedDescription)      //TODO: Error handling
                        }
                        else{
                            print("Successfully registered account name")
                            self.createAccountButton.removeFromSuperview()
                            self.activityIndicator.stopAnimating()
                            self.alertUser(title: "Account Created", message: "Welcome to Greeneum, \(Auth.auth().currentUser!.displayName!)!")     //Account created successfully
                        }
                    }
                }
                
            })
            
            
        }
        else if nameField.text == ""{
            let required = NSAttributedString(string: "Name Required!", attributes: [NSForegroundColorAttributeName: UIColor.red])      //Alerts user if fields are not filled out correctly
            nameField.attributedPlaceholder = required
        }
        else if emailField.text == "" {
            let required = NSAttributedString(string: "Email Required!", attributes: [NSForegroundColorAttributeName: UIColor.red])
            emailField.attributedPlaceholder = required
        }
        else if passwordField.text == "" {
            let required = NSAttributedString(string: "Password Required!", attributes: [NSForegroundColorAttributeName: UIColor.red])
            passwordField.attributedPlaceholder = required
        }
        else if passwordField2.text == "" {
            let required = NSAttributedString(string: "Please Retype Password!", attributes: [NSForegroundColorAttributeName: UIColor.red])
            passwordField2.attributedPlaceholder = required
        }
        else if passwordField.text != passwordField2.text{
            self.alertUser(title: "Password Mismatch", message: "The passwords do not match. Please retype your password.")
        }
    }

   
    @IBAction func backButton(_ sender: Any) {
        
        dismiss(animated: true, completion: nil)        //tapping the "Back" bar button dismisses the view
    }
    
    @IBAction func dismissKeyboard(_ sender: Any) {
        self.resignFirstResponder()     //This is so the keyboard is dismissed when "Done" is pressed
    }
    
    private func alertUser(title: String, message: String){     //Alerts the user with a UIAlertController
        
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let back = UIAlertAction(title: "Back", style: .cancel, handler: nil)
        alert.addAction(back)
        present(alert, animated: true, completion: nil)
        
        
    }


    
}
