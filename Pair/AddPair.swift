//
//  AddPair.swift
//  Pair
//
//  Created by Chris Fowles on 3/30/15.
//  Copyright (c) 2015 Chris Fowles. All rights reserved.
//

import UIKit

class AddPair: UIViewController {
    @IBOutlet weak var menuButton:UIBarButtonItem!
    
    func displayAlert(title: String, error: String){
        
        var alert = UIAlertController(title: title, message: error, preferredStyle: UIAlertControllerStyle.Alert)
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: { action in
            
            self.dismissViewControllerAnimated(true, completion: nil)
            
        }))
        
        self.presentViewController(alert, animated: true, completion: nil)
    }
    
    @IBOutlet var ingredientLabel: UILabel!

    @IBOutlet var ingredient: UITextField!
    
    @IBOutlet var pairLabel: UILabel!
    
    @IBOutlet var pair: UITextField!
    
    @IBOutlet var strengthLabel: UILabel!
    
    @IBOutlet var slider: UISlider!
    
    @IBOutlet var strengthNumber: UILabel!
    
    @IBAction func sliderValueChanged(sender: UISlider) {
        var currentValue = Int(sender.value)
        
        strengthNumber.text = "\(currentValue)"
        
    }
    
    
    @IBAction func addPair(sender: AnyObject) {
        
        let ingPair = [ingredient, pair]
        let sortedPair = ingPair.sorted { $0.text < $1.text }
        var ing = sortedPair[0].text
        var ing2 = sortedPair[1].text
        
        var query = PFQuery(className:"Pair")
        query.whereKey("ingredient", equalTo: ing.lowercaseString)
        query.whereKey("pair", equalTo: ing2.lowercaseString)
        query.getFirstObjectInBackgroundWithBlock {
            (object: PFObject!, error: NSError!) -> Void in
            if error != nil || object == nil {
                var ingredientPair = PFObject(className:"Pair")
                ingredientPair["ingredient"] = ing.lowercaseString
                ingredientPair["pair"] = ing2.lowercaseString
                ingredientPair["strength"] = Int(self.slider.value)
                ingredientPair["numEntries"] = 1
                ingredientPair["sum"] = Int(self.slider.value)
                ingredientPair.saveInBackgroundWithBlock {
                    (success: Bool, error: NSError!) -> Void in
                    if (success) {
                        self.displayAlert("Pair Added", error: "*knux")
                    } else {
                        // There was a problem, check error.description
                    }
                }
            } else {
                // The find succeeded
                println("Successfully retrieved the object, updating score.")
                var sum = object["sum"] as Int
                var n = object["numEntries"] as Int
                var s = Int(self.slider.value)
                var newStrength = (sum + s)/(n+1)
                object["strength"] = newStrength
                object["numEntries"] = n+1
                object["sum"] = sum + s
                object.save()
                self.displayAlert("Pair Updated", error: "The pair strength has been updated")
            }
        }
    
        //ingredientPair["ingredient"] = ing
        //ingredientPair["pair"] = ing2
        //ingredientPair["strength"] = slider.value
        
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if self.revealViewController() != nil {
            menuButton.target = self.revealViewController()
            menuButton.action = "revealToggle:"
            self.view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
            
            // Uncomment to change the width of menu
            //self.revealViewController().rearViewRevealWidth = 62
        }
    }
    
}
