//
//  ViewController.swift
//  SolarChange
//
//  Created by Jonathan Downing on 6/20/17.
//  Copyright © 2017 Jonathan Downing. All rights reserved.
//

import UIKit
import GoogleMobileAds

class ViewController: UIViewController, GADBannerViewDelegate {

    @IBOutlet weak var loadVideo: UIWebView!
    @IBOutlet weak var bannerView: GADBannerView!
    @IBOutlet weak var menuButton: UIBarButtonItem!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        bannerView.adSize = kGADAdSizeBanner        //Google Admob Banner characteristics
        bannerView.adUnitID = adID
        bannerView.rootViewController = self
        bannerView.load(GADRequest())
        self.view.addSubview(bannerView)
        
        loadVideo.allowsInlineMediaPlayback = true          //not sure if this does anything
        
        do {
            try AVAudioSession.sharedInstance().setCategory(AVAudioSessionCategoryPlayback)     //done in order to have sound without turning on ringer
            //print("AVAudioSession Category Playback OK")
            do {
                try AVAudioSession.sharedInstance().setActive(true)
                //print("AVAudioSession is Active")
            } catch {
                print(error.localizedDescription)
            }
        } catch {
            print(error.localizedDescription)
        }
        loadVideo.loadHTMLString("<iframe src=\"https://www.youtube.com/embed/R-FNmmIy2pY?&playsinline=1\" width=\"\(loadVideo.frame.width)\" height=\"\(loadVideo.frame.height)\" frameborder=\"0\" style=\"position:absolute;width:100%;height:100%;left:0\" allowfullscreen vq=hd720></iframe>", baseURL: nil)               //loads the video from Youtube (update the link whenever new video is released)
        
        
        
        

        
        sideMenu()      //runs the side menu function

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func sideMenu(){
        if revealViewController() != nil {                  //runs the sidebar menu via SWRevealViewController
            menuButton.target = revealViewController()
            menuButton.action = #selector(revealViewController().revealToggle(_:))
            revealViewController().rearViewRevealWidth = 315
            
            view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
        }
        
    
        
    }
    func adView(_ bannerView: GADBannerView,
                didFailToReceiveAdWithError error: GADRequestError) {
        print("adView:didFailToReceiveAdWithError: \(error.localizedDescription)")      //Hopefully will never run
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
