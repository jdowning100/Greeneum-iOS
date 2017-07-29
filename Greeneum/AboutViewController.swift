//
//  AboutViewController.swift
//  Greeneum
//
//  Created by Jonathan Downing on 6/21/17.
//  Copyright © 2017 Jonathan Downing. All rights reserved.
//

import UIKit
import GoogleMobileAds

class AboutViewController: UIViewController, GADBannerViewDelegate {
    
   
    @IBOutlet weak var menuButton: UIBarButtonItem!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var scrollView: UIScrollView!
    var bannerView: GADBannerView!
   
    override func viewDidLoad() { //Okay, so the StoryBoard version of this view is crazy complicated. I get it. I will convert it programatically when I get the chance.
        super.viewDidLoad()
        
        self.view.addSubview(scrollView)            //Is this needed? Probably not because everything is done in Storyboard. But Swift is weird sometimes.
        self.view.insertSubview(imageView, belowSubview: scrollView)

        bannerView = GADBannerView(adSize: kGADAdSizeSmartBannerPortrait)       //Done for Google Admob ads
        bannerView.adUnitID = adID
        bannerView.rootViewController = self
        bannerView.load(GADRequest())
        self.view.addSubview(bannerView)
        
        relayoutViews()
        
        sideMenu()
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillLayoutSubviews() {
        scrollView.contentSize = CGSize(width: 375, height: 6750)
    }
    
    func sideMenu(){                        //runs the sidebar menu via SWRevealViewController
        if revealViewController() != nil {
            menuButton.target = revealViewController()
            menuButton.action = #selector(revealViewController().revealToggle(_:))
            revealViewController().rearViewRevealWidth = 315
            
            view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
        }
    }
    
   
    
    func relayoutViews(){
        let screenRect = UIScreen.main.bounds       //centers the banner ad at the bottom of the screen
        var bannerFrame = bannerView.frame
        bannerFrame.origin.x = 0
        bannerFrame.origin.y = screenRect.size.height - bannerFrame.size.height
            
        bannerView.frame = bannerFrame
    
    }
    func adView(_ bannerView: GADBannerView,
                didFailToReceiveAdWithError error: GADRequestError) {
        print("adView:didFailToReceiveAdWithError: \(error.localizedDescription)")
    }

   

}
