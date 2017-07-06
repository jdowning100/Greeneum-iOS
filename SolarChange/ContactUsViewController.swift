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

class ContactUsViewController: UIViewController, GADBannerViewDelegate {

    @IBOutlet weak var doneLabel: UILabel!
    @IBOutlet weak var messageField: UITextField!
    @IBOutlet weak var emailField: UITextField!
    @IBOutlet weak var nameField: UITextField!
    @IBOutlet weak var menuButton: UIBarButtonItem!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var contentView: UIView!
    var bannerView: GADBannerView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        doneLabel.isHidden = true
        bannerView = GADBannerView(adSize: kGADAdSizeSmartBannerPortrait)
        bannerView.adUnitID = adID
        bannerView.rootViewController = self
        bannerView.load(GADRequest())
        self.view.addSubview(bannerView)
        bannerView.isHidden = true
        relayoutViews()
        
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
    func adView(_ bannerView: GADBannerView,
                didFailToReceiveAdWithError error: GADRequestError) {
        print("adView:didFailToReceiveAdWithError: \(error.localizedDescription)")
    }
    
    func adViewDidReceiveAd(_ bannerView: GADBannerView) {
        print("adViewDidReceiveAd:\(view)");
        
        bannerView.isHidden = false
    }

    
    func relayoutViews(){
        let screenRect = UIScreen.main.bounds
        var bannerFrame = bannerView.frame
        bannerFrame.origin.x = 0
        bannerFrame.origin.y = screenRect.size.height - bannerFrame.size.height
        
        bannerView.frame = bannerFrame
        
    }
    
    override func viewDidLayoutSubviews() {
        scrollView.layoutIfNeeded()
        scrollView.contentSize = contentView.bounds.size
        
    }

    @IBAction func dismissKeyboard(_ sender: Any) {
        self.resignFirstResponder()
    }
    

    
    @IBOutlet weak var sendbutton: UIButton!
    @IBOutlet weak var send: UILabel!
    
    @IBAction func sendButton(_ sender: Any) {
        
        self.sendbutton.removeFromSuperview()
        self.send.removeFromSuperview()
        var activityIndicator:UIActivityIndicatorView = UIActivityIndicatorView()
        activityIndicator.hidesWhenStopped = true
        
        
        
        activityIndicator.center = send.center
        activityIndicator.centerXAnchor.constraint(equalTo: sendbutton.centerXAnchor)
        activityIndicator.centerYAnchor.constraint(equalTo: sendbutton.centerYAnchor)
        activityIndicator.activityIndicatorViewStyle =  UIActivityIndicatorViewStyle.gray
        self.view.addSubview(activityIndicator)
        activityIndicator.startAnimating()
        
       
        let api = MandrillAPI(ApiKey: "_KCgVFRuhFXro0YKUpgTEw")
        
        api.sendEmail(from:    "info@solarchange.co",
                      fromName:"Greeneum",
                      to:      ["elya@solarchange.co","assaf@solarchange.co","jdowning@utexas.edu"],
                      subject: "Contact Us Greeneum (App)",
                      html:    "Name: \(nameField.text!) <br /><br />Email: \(emailField.text!) <br /><br />Message: \(messageField.text!)",
                      text:    ""){ mandrillResult in
                        if mandrillResult.success {
                            print("Email was sent!")
                            activityIndicator.stopAnimating()
                            self.doneLabel.isHidden = false
                            
                        }
        }
        
        
    }
}
