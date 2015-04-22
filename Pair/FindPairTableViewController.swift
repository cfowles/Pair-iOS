//
//  FindPairTableViewController.swift
//  Pair
//
//  Created by Chris Fowles on 4/3/15.
//  Copyright (c) 2015 Chris Fowles. All rights reserved.
//

import UIKit

class FindPairTableViewController: PFQueryTableViewController, UISearchBarDelegate {
    
    @IBOutlet weak var menuButton:UIBarButtonItem!

    @IBOutlet weak var searchBar: UISearchBar!
    
    // Initialise the PFQueryTable tableview
    override init!(style: UITableViewStyle, className: String!) {
        super.init(style: style, className: className)
    }
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        // Configure the PFQueryTableView
        self.parseClassName = "Pair"
        self.textKey = "ingredient"
        self.pullToRefreshEnabled = true
        self.paginationEnabled = false
    }
    
    // Define the query that will provide the data for the table view
    override func queryForTable() -> PFQuery! {
        var query = PFQuery(className: "Pair")
        if searchBar.text != "" {
            var ing = PFQuery(className: "Pair")
            ing.whereKey("ingredient", equalTo: searchBar.text)
            var p = PFQuery(className: "Pair")
            p.whereKey("pair", equalTo: searchBar.text)
            query = PFQuery.orQueryWithSubqueries([ing, p])
        }
        query.orderByAscending("ingredient")
        return query
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath, object: PFObject) -> PFTableViewCell {
        
        var cell = tableView.dequeueReusableCellWithIdentifier("Cell") as CustomCell!
        if cell == nil {
            cell = CustomCell(style: UITableViewCellStyle.Default, reuseIdentifier: "Cell")
        }
        
        // Extract values from the PFObject to display in the table cell
        cell.ingredient.text = object["ingredient"] as String!
        cell.pair.text = object["pair"] as String!
        let x = object["strength"] as Int!
        cell.strength.text = String(x)
        var iName : String = "thumbsDown"
        if x>6 {
            iName = "thumbsUp"
        }
        //let imageView = UIImageView(image:image)
        var image : UIImage = UIImage(named:iName)!
        cell.strengthIcon.image = image
        
        //var thumbnail = object["flag"] as PFFile
        //var initialThumbnail = UIImage(named: "question")
        //cell.customFlag.image = initialThumbnail
        //cell.customFlag.file = thumbnail
        //cell.customFlag.loadInBackground()
        
        return cell
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let cell = self.tableView.cellForRowAtIndexPath(indexPath) as CustomCell!
        // Create an instance of PlayerTableViewController and pass the variable
        self.performSegueWithIdentifier("recipeSegue", sender: cell)
        //let destinationVC = RecipeViewController()
        //destinationVC.ing1 = cell.ingredient.text
        //destinationVC.ing2 = cell.pair.text
        
        // Let's assume that the segue name is called playerSegue
        // This will perform the segue and pre-load the variable for you to use
        //destinationVC.performSegueWithIdentifier("recipeSegue", sender: self)
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if self.revealViewController() != nil {
            menuButton.target = self.revealViewController()
            menuButton.action = "revealToggle:"
            self.view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
            
            // Uncomment to change the width of menu
            //self.revealViewController().rearViewRevealWidth = 62
            
            // Refresh the table to ensure any data changes are displayed
            tableView.reloadData()
            
            // Delegate the search bar to this table view class
            searchBar.delegate = self
        }
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        if segue.identifier == "recipeSegue"{
         var dest = segue.destinationViewController as RecipeViewController
         dest.ing1 = (sender as CustomCell).ingredient.text
         dest.ing2 = (sender as CustomCell).pair.text
        }
    }
    
    
    func searchBarTextDidEndEditing(searchBar: UISearchBar) {
        
        // Dismiss the keyboard
        searchBar.resignFirstResponder()
        
        // Force reload of table data
        self.loadObjects()
    }
    
    func searchBarSearchButtonClicked(searchBar: UISearchBar) {
        
        // Dismiss the keyboard
        searchBar.resignFirstResponder()
        
        // Force reload of table data
        self.loadObjects()
    }
    
    func searchBarCancelButtonClicked(searchBar: UISearchBar) {
        
        // Clear any search criteria
        searchBar.text = ""
        
        // Dismiss the keyboard
        searchBar.resignFirstResponder()
        
        // Force reload of table data
        self.loadObjects()
    }
    

}
