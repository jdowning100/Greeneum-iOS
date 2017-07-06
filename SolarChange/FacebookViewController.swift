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
       // likeButton = FBSDKLikeButton()
       // self.view.addSubview(likeButton)
        likeButton.frame = likeButton.frame
        likeButton.objectID = "https://www.facebook.com/SolarChange-1692268627697921"
        sideMenu()
        //likeButton.center = self.view.center
        webView.loadRequest(NSURLRequest(url: URL(string: "https://m.facebook.com/SolarChange-1692268627697921/posts/")!) as URLRequest)
        // Do any additional setup after loading the view.
    }

    
    func sideMenu(){
        if revealViewController() != nil {
            menuButton.target = revealViewController()
            menuButton.action = #selector(revealViewController().revealToggle(_:))
            revealViewController().rearViewRevealWidth = 315
            
            view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
        }
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
