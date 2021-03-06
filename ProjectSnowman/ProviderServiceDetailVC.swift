//
//  ProviderServerDetailVC.swift
//  ProjectSnowman
//
//  Created by Michael Litman on 4/26/16.
//  Copyright © 2016 iLash. All rights reserved.
//

import UIKit
import Firebase

class ProviderServiceDetailVC: UIViewController {
    
    @IBOutlet weak var addressLabel: UILabel!
    @IBOutlet weak var completeButton: UIButton!
    @IBOutlet weak var claimButton: UIButton!
    @IBOutlet weak var instructionsLabel: UILabel!
    @IBOutlet weak var instructionsTextView: UITextView!
    @IBOutlet weak var sizeValueLabel: UILabel!
    @IBOutlet weak var offerValueLabel: UILabel!
    @IBOutlet weak var typeValueLabel: UILabel!
    @IBOutlet weak var navBar: UINavigationBar!
    var req : ServiceRequest!
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        //get the profile of the user so we can show the address
        let ref = Core.fireBaseRef.childByAppendingPath("profile").childByAppendingPath(req.user)
        ref.observeSingleEventOfType(.Value) { (snapshot: FDataSnapshot!) in
            let profile = snapshot.value as! [String : String]
            let address = "\(profile["first_name"]!) \(profile["last_name"]!)\n\(profile["street1"]!)\n\(profile["street2"]!)\n\(profile["city"]!), \(profile["state"]!) \(profile["zip"]!)"
            self.addressLabel.text = address
        }
        
        if(req.provider == "n/a")
        {
            claimButton.hidden = false
            completeButton.hidden = true
        }
        else
        {
            claimButton.hidden = true
            completeButton.hidden = false
        }
        if(req.instructions == "")
        {
            instructionsLabel.hidden = true
            instructionsTextView.hidden = true
        }
        else
        {
            instructionsTextView.text = req.instructions
        }
        sizeValueLabel.text = req.size
        offerValueLabel.text = "$\((Double(req.cost)/100.0)*Core.providerCut)"
        typeValueLabel.text = req.type
        navBar.topItem?.title = req.name
    }

    @IBAction func claimButtonPressed(sender: AnyObject)
    {
        let vc = UIAlertController(title: "Claim Confirmation", message: "Are you sure you want to claim this service request?", preferredStyle: .Alert)
        let cancelAction = UIAlertAction(title: "Cancel", style: .Cancel, handler: nil)
        let confirmAction = UIAlertAction(title: "Confirm", style: .Default) { (action) in
            self.req.provider = Core.fireBaseRef.authData.uid
            let ref = Core.fireBaseRef.childByAppendingPath("service_requests").childByAppendingPath(self.req.key)
            ref.updateChildValues(["provider" : self.req.provider])
            self.dismissViewControllerAnimated(true, completion: nil)
        }
        vc.addAction(cancelAction)
        vc.addAction(confirmAction)
        self.presentViewController(vc, animated: true, completion: nil)
    }
    
    @IBAction func completeButtonPressed(sender: AnyObject)
    {
        let vc = UIAlertController(title: "Complete Confirmation", message: "Are you sure you want to complete this service request?", preferredStyle: .Alert)
        let cancelAction = UIAlertAction(title: "Cancel", style: .Cancel, handler: nil)
        let confirmAction = UIAlertAction(title: "Confirm", style: .Default) { (action) in
            self.req.completed = true
            let ref = Core.fireBaseRef.childByAppendingPath("service_requests").childByAppendingPath(self.req.key)
            ref.updateChildValues(["completed" : self.req.completed])
            self.dismissViewControllerAnimated(true, completion: nil)
        }
        vc.addAction(cancelAction)
        vc.addAction(confirmAction)
        self.presentViewController(vc, animated: true, completion: nil)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
