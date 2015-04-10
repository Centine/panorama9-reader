//
//  SetupViewController.swift
//  Panorama9 Reader
//
//  Created by Jan Wiberg on 18/03/15.
//  Copyright (c) 2015 panorama9. All rights reserved.
//

import UIKit

class SetupViewController : UIViewController, UITextFieldDelegate {
    
    @IBOutlet weak var apiKeyField: UITextField!
    @IBOutlet weak var connectResponseLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let defaults = NSUserDefaults.standardUserDefaults()
        let lastConnect:NSInteger = defaults.integerForKey("p9LastConnect")
        if lastConnect > 0 {
            connectResponseLabel.text = "Previously Connected"
        }
        if let storedApiKey = defaults.stringForKey("p9ApiKey") {
            apiKeyField.text = storedApiKey
        }
    }
    
    @IBAction func ConnectTapped(sender: AnyObject) {
        connectResponseLabel.text = "Testing..."
        let api = RestAPI()
        if !api.isAuthable(apiKeyField.text) {
            connectResponseLabel.text = "Key must be 64 hex digits"
            return
        }
        api.setAuthKey(apiKeyField.text)
        api.getDictionary("identity", completion: dataReceiveComplete, failure: dataReceiveError)
        
    }
    
    func dataReceiveComplete(data: NSDictionary?) {
        connectResponseLabel.text = "Received..."
        var msg: String
        
        if let type:String = data?.objectForKey("type") as? String {
            if type == "customer" {
                let name = data?.objectForKey("name") as? String ?? ""
                msg = "Welcome \(name)"

                var date = NSDate()
                let defaults = NSUserDefaults.standardUserDefaults()
                defaults.setObject(apiKeyField.text, forKey: "p9ApiKey")
                defaults.setInteger(NSInteger(date.timeIntervalSince1970), forKey: "p9LastConnect")
            } else {
                msg = "Only works for customers"
            }
        } else {
            msg = "Unexpected data"
        }
        
        connectResponseLabel.text = msg
    }
    
    func dataReceiveError(message: String?) {
        let alert = UIAlertController(title: "Network error", message: message, preferredStyle: UIAlertControllerStyle.Alert)
        alert.addAction(UIAlertAction(title: "Cancel", style: UIAlertActionStyle.Default, handler: nil))
        self.presentViewController(alert, animated: true, completion: nil)
        
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool
    {
        textField.resignFirstResponder()
        return true;
    }
}
