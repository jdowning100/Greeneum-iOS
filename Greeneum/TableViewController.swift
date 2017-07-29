//
//  TableViewController.swift
//  Greeneum
//
//  Created by Jonathan Downing on 6/25/17.
//  Copyright © 2017 Jonathan Downing. All rights reserved.
//

import UIKit
import TwitterKit
import FacebookShare

class TableViewController: UITableViewController {

    @IBOutlet weak var Share: UITableViewCell!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.backgroundColor = UIColor(patternImage: UIImage(named: "bg-cropped.png")!)    //adds a background image, not sure why it's included in the status bar

        }

    
    
      override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {      //selecting the share button in side menu

        if(indexPath.row == 8){
            print("Share button tapped")
            
            let alert = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
            alert.addAction(UIAlertAction(title: "Share on Twitter", style: .default) { action in
                
                let composer = TWTRComposer()       //TwitterKit tweet composer
            
                composer.setText("Follow Greeneum on Twitter!")         //Defaults that are automatically placed in the tweet, update as you'd like
                composer.setImage(UIImage(named: "logo-top"))
                composer.setURL(URL(string: "https://twitter.com/Greeneum1"))
                
                
                composer.show(from: self) { result in       //shows the tweet composer
                    if (result == .done) {
                    print("Successfully composed Tweet")        //TODO: Save shares to Firebase account (if logged in)
                    } else {
                    print("Cancelled composing")
                    }
                }
 
                
            })
            alert.addAction(UIAlertAction(title: "Share on Facebook", style: .default) { action in
                let myContent = LinkShareContent(url: URL(string: "https://www.facebook.com/SolarChange-1692268627697921")!, title: "Greeneum", description: "Like Greeneum on Facebook") //IMPORTANT: UPDATE LINK WHEN FACEBOOK ACCOUNT IS LIVE
                
                let shareDialog = ShareDialog(content: myContent)       //Facebook Swift SDK share
                shareDialog.mode = .native
                shareDialog.failsOnInvalidData = true
                shareDialog.completion = { result in
                    // Handle share results                         //TODO: Save shares to Firebase account (if logged in)
                }
                shareDialog.presentingViewController = self
                try! shareDialog.show()
                
            })
            alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))       //in case user accidentally hit the button
            self.present(alert, animated: true, completion: nil)
        
        }
    }

    
}
