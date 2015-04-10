//
//  ViewController.swift
//  Panorama9 Reader
//
//  Created by Jan Wiberg on 18/03/15.
//  Copyright (c) 2015 panorama9. All rights reserved.
//

import UIKit

class CategoryTableViewController: UITableViewController, UITableViewDataSource, UITableViewDelegate {

    let p9Categories = ["Devices", "Issues", "Software"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return p9Categories.count
    }
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("CategoryCell") as! UITableViewCell
        let row = indexPath.row
        cell.textLabel?.text = p9Categories[row]
        return cell
    }
    
    @IBAction func close(segue: UIStoryboardSegue) {
        println("Closing modal dialog")
    }
    
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        
        let row = indexPath.row
        println(p9Categories[row])
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "GoToObjectView" {
            if let selectedCategory = self.tableView.indexPathForCell(sender as! UITableViewCell) {
                let otvController = segue.destinationViewController as! ObjectTableViewController
                otvController.category = p9Categories[selectedCategory.row]
            }
        }
    }

}

