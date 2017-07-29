//
//  ContributeViewController.swift
//  Greeneum
//
//  Created by Jonathan Downing on 7/23/17.
//  Copyright © 2017 Jonathan Downing. All rights reserved.
//

import UIKit
import GoogleMobileAds

class ContributeViewController: UIViewController {

    @IBOutlet weak var menuButton: UIBarButtonItem!
    var bannerView: GADBannerView!
    
    override func viewDidLoad() {                       //TODO: Update this view when the ICO launch date is revealed and again when it launches
        super.viewDidLoad()
        
        bannerView = GADBannerView(adSize: kGADAdSizeSmartBannerPortrait)       //Google Admob Ad configuration
        bannerView.adUnitID = adID
        bannerView.rootViewController = self
        bannerView.load(GADRequest())
        self.view.addSubview(bannerView)
        
        relayoutViews()
        
        sideMenu()


       
    }
    
    func sideMenu(){        //runs the sidebar menu via SWRevealViewController
        if revealViewController() != nil {
            menuButton.target = revealViewController()
            menuButton.action = #selector(revealViewController().revealToggle(_:))
            revealViewController().rearViewRevealWidth = 315
            
            view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
        }
    }

    func relayoutViews(){           //centers the banner at at the bottom of the screen
        let screenRect = UIScreen.main.bounds
        var bannerFrame = bannerView.frame
        bannerFrame.origin.x = 0
        bannerFrame.origin.y = screenRect.size.height - bannerFrame.size.height
        
        bannerView.frame = bannerFrame
        
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
