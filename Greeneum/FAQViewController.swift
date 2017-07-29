//
//  FAQViewController.swift
//  Greeneum
//
//  Created by Jonathan Downing on 7/1/17.
//  Copyright © 2017 Jonathan Downing. All rights reserved.
//

import UIKit
import GoogleMobileAds

class FAQViewController: UIViewController, GADBannerViewDelegate {

    @IBOutlet weak var contentView: UIView!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var menuButton: UIBarButtonItem!
    var bannerView: GADBannerView!
    
    override func viewDidLoad() {           //Okay, so the StoryBoard version of this view is crazy complicated. I get it. I will convert it programatically when I get the chance.
        super.viewDidLoad()
        
        bannerView = GADBannerView(adSize: kGADAdSizeSmartBannerPortrait)       //Google Admob config
        bannerView.adUnitID = adID
        bannerView.rootViewController = self
        bannerView.load(GADRequest())
        self.view.addSubview(bannerView)
        
        relayoutViews()
        
        sideMenu()
    
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func sideMenu(){        //runs the sidebar menu via SWRevealViewController
        if revealViewController() != nil {
            menuButton.target = revealViewController()
            menuButton.action = #selector(revealViewController().revealToggle(_:))
            revealViewController().rearViewRevealWidth = 315
            
            view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
        }
        
        
        
    }
    func adView(_ bannerView: GADBannerView,
                didFailToReceiveAdWithError error: GADRequestError) {
        print("adView:didFailToReceiveAdWithError: \(error.localizedDescription)")      //just for debug, hopefully this will never run
    }
    
    func adViewDidReceiveAd(_ bannerView: GADBannerView) {
        print("adViewDidReceiveAd:\(view)");
        
        relayoutViews()
    }

    
    func relayoutViews(){       //Centers the banner ad at the bottom of the screen
        let screenRect = UIScreen.main.bounds
        var bannerFrame = bannerView.frame
        bannerFrame.origin.x = 0
        bannerFrame.origin.y = screenRect.size.height - bannerFrame.size.height
        
        bannerView.frame = bannerFrame
        
    }
    
    override func viewDidLayoutSubviews() {     //Is this needed? Probably not because everything is done in Storyboard. But Swift is weird sometimes.
        scrollView.layoutIfNeeded()
        scrollView.contentSize = contentView.bounds.size
        
    }
    @IBAction func openLink(_ sender: Any) {
        UIApplication.shared.openURL(URL(string: "http://greeneum.net/#!/faq")!)        //for the button at the bottom of the FAQ, update this link if neccessary
    }

}
