//
//  LogInViewController.swift
//  Greeneum
//
//  Created by Jonathan Downing on 7/11/17.
//  Copyright © 2017 Jonathan Downing. All rights reserved.
//

import UIKit
import Firebase
import NVActivityIndicatorView
import FirebaseAuth
import ReCaptcha
import FBSDKLoginKit

class LogInViewController: UIViewController, FBSDKLoginButtonDelegate {

    @IBOutlet weak var FBlogin: FBSDKLoginButton?
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var activityIndicator: NVActivityIndicatorView!
    @IBOutlet weak var password: UITextField!
    @IBOutlet weak var username: UITextField!
    @IBOutlet weak var menuButton: UIBarButtonItem!
    
    let recaptcha = try? ReCaptcha()
    
    override func viewDidLoad() {
        
        recaptcha?.configureWebView { [weak self] webview in
            webview.translatesAutoresizingMaskIntoConstraints = false
            webview.frame = self?.view.bounds ?? CGRect.zero
        }
        
        //self.FBlogin = FBSDKLoginButton(readPermissions: [.publicProfile, .email])
        FBlogin?.delegate = self
        FBlogin?.readPermissions = ["public_profile","email"]
        super.viewDidLoad()
        sideMenu()
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func sideMenu(){
        if revealViewController() != nil {
            menuButton.target = revealViewController()
            menuButton.action = #selector(revealViewController().revealToggle(_:))
            revealViewController().rearViewRevealWidth = 315
            
            view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
        }
    }


    @IBAction func login(_ sender: Any) {
        guard Auth.auth().currentUser == nil else {
            self.alertUser(title: "Already logged in", message: "Already logged in as \(Auth.auth().currentUser!.displayName!)")
            return
        }
        guard FBSDKAccessToken.current() == nil else {
            self.alertUser(title: "Already logged in", message: "Already logged in as \(FBSDKAccessToken.current().userID)")
            return
        }
        validate()
        
        if username.text != nil && password.text != nil{
            self.loginButton.isHidden = true
            activityIndicator.startAnimating()
            
            
            Auth.auth().signIn(withEmail: username.text!, password: password.text!) { (user, error) in
                if(error != nil){
                    print(error!.localizedDescription)
                    if let errCode = AuthErrorCode(rawValue: error!._code) {
                        
                       switch errCode {
                       case .invalidEmail:
                            self.alertUser(title: "Invalid Email or Password", message: "Please try again. If you haven't yet created an account, tap on \"Create New Account\"")
                            self.password.text = ""
                       case .wrongPassword:
                            self.alertUser(title: "Invalid Email or Password", message: "Please try again. If you haven't yet created an account, tap on \"Create New Account\"")
                            self.password.text = ""
                       case .accountExistsWithDifferentCredential:
                            self.alertUser(title: "Invalid Email or Password", message: "Please try again. If you haven't yet created an account, tap on \"Create New Account\"")
                            self.password.text = ""
                       case .userDisabled:
                            self.alertUser(title: "Account Disabled", message: "This account has been locked by an administrator. Please contact the Greeneum admin team.")
                       case .networkError:
                            self.alertUser(title: "Network Error", message: "Error connecting with server. Please check your internet connection and try again. Server downtime will be posted on the Greeneum Twitter.")

                       default:
                        self.alertUser(title: "Unexpected Error", message: "Error: \(error!)")
                        
                        
                        }
                        self.activityIndicator.stopAnimating()
                        self.loginButton.isHidden = false
                    }
                        
                    
                }
                else {
                    print("Log in successful")
                    self.activityIndicator.stopAnimating()
                    self.alertUser(title: "Login Successful!", message: "Logged in as \(user!.displayName!)")
                    self.loginButton.removeFromSuperview()
                }
            }
            
        }
        else if username.text == "" {
            let required = NSAttributedString(string: "Email Required!", attributes: [NSForegroundColorAttributeName: UIColor.red])
            username.attributedPlaceholder = required
        }
        else if password.text == "" {
            let required = NSAttributedString(string: "Password Required!", attributes: [NSForegroundColorAttributeName: UIColor.red])
            password.attributedPlaceholder = required
        }

        else{
            print("Something is wrong in the text fields")
        }
    }
    
    @IBAction func logOut(_ sender: Any) {
        guard Auth.auth().currentUser != nil else {
            self.alertUser(title: "Already logged out", message: "You have already been logged out.")
            return
        }
        if FBSDKAccessToken.current() != nil{
            let logout = FBSDKLoginManager()
            logout.logOut()
            loginButtonDidLogOut(FBlogin)
        }
        let firebaseAuth = Auth.auth()
        do {
            try firebaseAuth.signOut()
            self.alertUser(title: "Log Out Successful", message: "")
        } catch let signOutError as NSError {
            if let errCode = AuthErrorCode(rawValue: signOutError._code) {
                switch errCode {
                case .sessionExpired:
                    self.alertUser(title: "Already logged out", message: "You have already been logged out.")
                case .userTokenExpired:
                    self.alertUser(title: "Already logged out", message: "You have already been logged out.")
                case .invalidUserToken:
                    self.alertUser(title: "Already logged out", message: "You have already been logged out.")
                case .networkError:
                    self.alertUser(title: "Network Error", message: "Error connecting with server. Please check your internet connection and try again. Server downtime will be posted on the Greeneum Twitter.")
                default:
                    self.alertUser(title: "Unexpected Error", message: "Error: \(signOutError)")
                }
            
            
            }
            
            print ("Error signing out: %@", signOutError)
        }
        
    }
    @IBAction func dismissKeyboard(_ sender: Any) {
        self.resignFirstResponder()
    }

    private func alertUser(title: String, message: String){
        
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let back = UIAlertAction(title: "Back", style: .cancel, handler: nil)
        alert.addAction(back)
        present(alert, animated: true, completion: nil)
        
    
    }
    
    func validate() {
        recaptcha?.validate(on: view) { [weak self] result in
            print(try? result.dematerialize())
            print("Captcha validation")
        }
    }
    
    func loginButtonDidLogOut(_ loginButton: FBSDKLoginButton!) {
        print("Logged out of Facebook")

        guard Auth.auth().currentUser != nil else {
            print("Error: Firebase already logged out without logging out Facebook")
            return
        }

        let firebaseAuth = Auth.auth()
        do {
            try firebaseAuth.signOut()
            self.alertUser(title: "Log Out Successful", message: "")
        } catch let signOutError as NSError {
            if let errCode = AuthErrorCode(rawValue: signOutError._code) {
                switch errCode {
                case .sessionExpired:
                    self.alertUser(title: "Already logged out", message: "You have already been logged out.")
                case .userTokenExpired:
                    self.alertUser(title: "Already logged out", message: "You have already been logged out.")
                case .invalidUserToken:
                    self.alertUser(title: "Already logged out", message: "You have already been logged out.")
                case .networkError:
                    self.alertUser(title: "Network Error", message: "Error connecting with server. Please check your internet connection and try again. Server downtime will be posted on the Greeneum Twitter.")
                default:
                    self.alertUser(title: "Unexpected Error", message: "Error: \(signOutError)")
                }
                
                
            }
            
            print ("Error signing out: %@", signOutError)
        }

        print("Logged out of Facebook")
    }
    
    func loginButton(_ loginButton: FBSDKLoginButton!, didCompleteWith result: FBSDKLoginManagerLoginResult!, error: Error!) {
        guard Auth.auth().currentUser == nil else {
            self.alertUser(title: "Already logged in", message: "Already logged in as \(Auth.auth().currentUser!.displayName!)")
            return
        }
        if error != nil{
            print(error.localizedDescription)
            return
        }
        else if(result.isCancelled){
            alertUser(title: "Error: Please accept login", message: "")
            return
        }
        
        guard let accessToken = FBSDKAccessToken.current() else {
            print("Failed to get access token")
            return
            }
            
        let credential = FacebookAuthProvider.credential(withAccessToken: accessToken.tokenString)
            
        Auth.auth().signIn(with: credential) { (user, error) in
            if(error != nil){
            if let errCode = AuthErrorCode(rawValue: error!._code) {
                print(errCode.rawValue)
                return
                }
            }
            else{
                self.alertUser(title: "Login Successful!", message: "Logged in as \(user!.displayName!)")
                
            }
            
        }
        
        
    }
   
    
}
    
    

