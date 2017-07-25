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
        
        bannerView.adSize = kGADAdSizeBanner
        bannerView.adUnitID = adID
        bannerView.rootViewController = self
        bannerView.load(GADRequest())
        self.view.addSubview(bannerView)
        
        loadVideo.allowsInlineMediaPlayback = true
        do {
            try AVAudioSession.sharedInstance().setCategory(AVAudioSessionCategoryPlayback)
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
        loadVideo.loadHTMLString("<iframe src=\"https://www.youtube.com/embed/R-FNmmIy2pY?&playsinline=1\" width=\"\(loadVideo.frame.width)\" height=\"\(loadVideo.frame.height)\" frameborder=\"0\" style=\"position:absolute;width:100%;height:100%;left:0\" allowfullscreen vq=hd720></iframe>", baseURL: nil)
        
        
        
        

        
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
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
