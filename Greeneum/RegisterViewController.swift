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
        
        
        // Do any additional setup after loading the view.
    }
    @IBAction func createAccount(_ sender: Any) {
        
        

        if nameField.text != "" && emailField.text != "" && passwordField.text != "" && passwordField.text == passwordField2.text{
            self.activityIndicator.startAnimating()
            self.createAccountButton.removeFromSuperview()

            self.activityIndicator.startAnimating()
            self.createAccountButton.removeFromSuperview()
            
            
            Auth.auth().createUser(withEmail: emailField.text!, password: passwordField.text!, completion: { user, error in
                if(error != nil){
                    print(error!.localizedDescription)
                    return
                }
                else{
                    print("Successfully registered account email and password")
                }
                
            })
            let changeRequest = Auth.auth().currentUser?.createProfileChangeRequest()
            changeRequest?.displayName = nameField.text
            changeRequest?.commitChanges { (error) in
                if(error != nil){
                    print(error!.localizedDescription)
                }
                else{
                    print("Successfully registered account name")
                    self.activityIndicator.stopAnimating()
                }
            }
            
        }
        else if nameField.text == ""{
            let required = NSAttributedString(string: "Name Required!", attributes: [NSForegroundColorAttributeName: UIColor.red])
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
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func backButton(_ sender: Any) {
        
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func dismissKeyboard(_ sender: Any) {
        self.resignFirstResponder()
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
