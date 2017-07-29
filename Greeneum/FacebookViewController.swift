//
//  FacebookViewController.swift
//  Greeneum
//
//  Created by Jonathan Downing on 6/20/17.
//  Copyright © 2017 Jonathan Downing. All rights reserved.
//

import UIKit
import FacebookShare
import FacebookCore
import FBSDKShareKit
import FBSDKLoginKit
class FacebookViewController: UIViewController{

    
    @IBOutlet weak var webView: UIWebView!
    @IBOutlet weak var menuButton: UIBarButtonItem!
    @IBOutlet weak var likeButton: FBSDKLikeButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        likeButton.frame = likeButton.frame
        likeButton.objectID = "https://www.facebook.com/SolarChange-1692268627697921"           //IMPORTANT: UPDATE THIS LINK WHEN THE FACEBOOK PAGE IS LIVE
        sideMenu()
        webView.loadRequest(NSURLRequest(url: URL(string: "https://m.facebook.com/SolarChange-1692268627697921/posts/")!) as URLRequest)  //IMPORTANT: UPDATE THIS LINK WHEN THE FACEBOOK PAGE IS LIVE
                //instead of recreating the Facebook newsfeed/page view I decided to just use their mobile website
    }

    
    func sideMenu(){                        //runs the sidebar menu via SWRevealViewController
        if revealViewController() != nil {
            menuButton.target = revealViewController()
            menuButton.action = #selector(revealViewController().revealToggle(_:))
            revealViewController().rearViewRevealWidth = 315
            
            view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
        }
    }
    
 

}
