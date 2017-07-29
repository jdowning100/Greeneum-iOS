//
//  FAQViewController.swift
//  Greeneum
//
//  Created by Jonathan Downing on 7/1/17.
//  Copyright © 2017 Jonathan Downing. All rights reserved.
//

import UIKit
import GoogleMobileAds
//import MessageUI
import SwiftMandrill
import NVActivityIndicatorView

class ContactUsViewController: UIViewController, GADBannerViewDelegate {

    @IBOutlet weak var activityIndicator: NVActivityIndicatorView!
    @IBOutlet weak var messageField: UITextField!
    @IBOutlet weak var emailField: UITextField!
    @IBOutlet weak var nameField: UITextField!
    @IBOutlet weak var menuButton: UIBarButtonItem!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var contentView: UIView!
    var bannerView: GADBannerView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        bannerView = GADBannerView(adSize: kGADAdSizeSmartBannerPortrait)       //Google Admob config
        bannerView.adUnitID = adID
        bannerView.rootViewController = self
        bannerView.load(GADRequest())
        self.view.addSubview(bannerView)
        relayoutViews()
        
        sideMenu()
   
    }
    
    
    func sideMenu(){             //runs the sidebar menu via SWRevealViewController
        if revealViewController() != nil {
            menuButton.target = revealViewController()
            menuButton.action = #selector(revealViewController().revealToggle(_:))
            revealViewController().rearViewRevealWidth = 315
            
            view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
        }
        
        
        
    }
    func adView(_ bannerView: GADBannerView,
                didFailToReceiveAdWithError error: GADRequestError) {       //just for debug, hopefully it never runs
        print("adView:didFailToReceiveAdWithError: \(error.localizedDescription)")
    }
    

    
    func relayoutViews(){
        let screenRect = UIScreen.main.bounds                    //Centers the banner ad at the bottom of the screen
        var bannerFrame = bannerView.frame
        bannerFrame.origin.x = 0
        bannerFrame.origin.y = screenRect.size.height - bannerFrame.size.height
        
        bannerView.frame = bannerFrame
        
    }
    
    override func viewDidLayoutSubviews() {
        scrollView.layoutIfNeeded()         //For scrollview, probably not needed
        scrollView.contentSize = contentView.bounds.size
        
    }

    @IBAction func dismissKeyboard(_ sender: Any) {
        self.resignFirstResponder()         //Dismisses the keyboard when "Done" is tapped
    }
    

    
    @IBOutlet weak var sendbutton: UIButton!
    @IBOutlet weak var send: UILabel!
    
    @IBAction func sendButton(_ sender: Any) {
        if nameField.text != "" && messageField.text != ""{     //Check to make sure fields are filled out
        self.sendbutton.removeFromSuperview()           //removes buttons because they won't be needed
        self.send.removeFromSuperview()
        
        self.activityIndicator.color = UIColor.darkGray     //activity indicator config
        self.activityIndicator.startAnimating()
        
       
        let api = MandrillAPI(ApiKey: "_KCgVFRuhFXro0YKUpgTEw")         //uses SwiftMandrill to send email
        
        api.sendEmail(from:    "info@solarchange.co",
                      fromName:"Greeneum",
                      to:      ["elya@solarchange.co","assaf@solarchange.co","jdowning@utexas.edu"],        //Update this as neccessary
                      subject: "Contact Us Greeneum (App)",
                      html:    "Name: \(nameField.text!) <br /><br />Email: \(emailField.text!) <br /><br />Message: \(messageField.text!)",    //this includes HTML, not entirely Swift
                      text:    ""){ mandrillResult in
                        if mandrillResult.success {
                            print("Email was sent!")
                            self.activityIndicator.stopAnimating()
                            self.alertUser(title: "Email Sent", message: "Thank you for contacting us. We will reach out to you shortly.")
                            
                        }
        }
        
        
        }
        else {
            alertUser(title: "Error", message: "Please make sure you've filled out the fields entirely.")
        }
    }
    
    private func alertUser(title: String, message: String){     //Alerts the user with a UIAlertController
        
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let back = UIAlertAction(title: "Back", style: .cancel, handler: nil)
        alert.addAction(back)
        present(alert, animated: true, completion: nil)
        
        
    }
}
