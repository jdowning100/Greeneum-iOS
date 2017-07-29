//
//  TwitterViewController.swift
//  SolarChange
//
//  Created by Jonathan Downing on 6/20/17.
//  Copyright © 2017 Jonathan Downing. All rights reserved.
//

import UIKit
import TwitterKit
class TwitterViewController: TWTRTimelineViewController {

    
    @IBOutlet weak var menuButton: UIBarButtonItem!
       override func viewDidLoad() {
        super.viewDidLoad()
        sideMenu()                      //runs the sidebar
        let client = TWTRAPIClient()
        self.dataSource = TWTRUserTimelineDataSource(screenName: "Greeneum1", apiClient: client)        //update screenName if necessary, otherwise TwitterKit does everything on its own
        self.showTweetActions = true        //useful for sharing/liking tweets
        // Do any additional setup after loading the view.
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


    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */


}
