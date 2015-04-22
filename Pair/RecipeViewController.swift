//
//  RecipeViewController.swift
//  Pair
//
//  Created by Chris Fowles on 4/12/15.
//  Copyright (c) 2015 Chris Fowles. All rights reserved.
//

import UIKit

class RecipeViewController: UIViewController {
    var ing1 : String?
    var ing2 : String?
    @IBOutlet weak var webView: UIWebView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        var u = "http://www.recipepuppy.com/"+String(ing1!)+"/"+String(ing2!)
        u = u.stringByAddingPercentEscapesUsingEncoding(NSUTF8StringEncoding)!
        println(u)
        let url = NSURL(string: "http://www.recipepuppy.com/?i=\(String(ing1!))%2C+\(String(ing2!))&q=")
        let request = NSURLRequest(URL: url!)
        webView.loadRequest(request)
        // Do any additional setup after loading the view.
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
