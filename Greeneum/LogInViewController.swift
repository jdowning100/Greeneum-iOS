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

class LogInViewController: UIViewController {

    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var loginText: UILabel!
    @IBOutlet weak var activityIndicator: NVActivityIndicatorView!
    @IBOutlet weak var password: UITextField!
    @IBOutlet weak var username: UITextField!
    @IBOutlet weak var menuButton: UIBarButtonItem!
    override func viewDidLoad() {
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
        if username.text != nil && password.text != nil{
            self.loginButton.removeFromSuperview()
            activityIndicator.startAnimating()
            
            
            Auth.auth().signIn(withEmail: username.text!, password: password.text!) { (user, error) in
                if(error != nil){
                    print(error!.localizedDescription)
                    if let errCode = AuthErrorCode(rawValue: error!._code) {
                        
                       /* switch errCode {
                        case .FIRAuthErrorCodeInvalidEmail:
                            print("invalid email")
                        case .FIRAuthErrorCodeWrongPassword:
                            print("in use")
                        default:
                            print("Create User Error: \(error!)")
                        }
 */
                    }
                        
                    
                }
                else {
                    print("Log in successful")
                    self.activityIndicator.stopAnimating()
                    self.loginText.isHidden = false
                }
            }
            
        }
        else{
            print("Something is wrong in the text fields")
        }
    }
    
    @IBAction func logOut(_ sender: Any) {
        
        let firebaseAuth = Auth.auth()
        do {
            try firebaseAuth.signOut()
        } catch let signOutError as NSError {
            print ("Error signing out: %@", signOutError)
        }
        
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
