//
//  ObjectTableViewController.swift
//  Panorama9 Reader
//
//  Created by Jan Wiberg on 18/03/15.
//  Copyright (c) 2015 panorama9. All rights reserved.
//

import UIKit

class ObjectTableViewController : UITableViewController {
    var category: String?
    var tableData: NSArray?
    let issueCategories: [String] = ["Vulnerability", "Availability", "Compliance"]
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        self.title = category
        
        let api: RestAPI = RestAPI()
        api.establishAuth()
        println("Category is \(category!.lowercaseString)")
        api.getList(self.category!.lowercaseString, completion: dataReceiveComplete, failure: dataReceiveError)

    }
    func dataReceiveComplete(data: NSArray?) -> Void {
        println("foo \(data?.count)")
        if (data == nil)
        {
            return
        }
        if (self.category == "Issues" && data != nil) {
            let split: [NSMutableArray] = [NSMutableArray(), NSMutableArray(), NSMutableArray()]
            for (index, element) in enumerate(data!) {
                if let ele: NSDictionary = element as? NSDictionary, let area: String = ele.objectForKey("area") as? String {
                    if area == "vulnerability" {
                        split[0].addObject(element)
                    } else if area == "availability" {
                        split[1].addObject(element)
                    } else {
                        split[2].addObject(element)
                    }
                }
            }
            tableData = split
        } else {
            tableData = data
        }
        tableView.reloadData()
    }
    
    func dataReceiveError(message: String?) {
        let alert = UIAlertController(title: "Network error", message: message, preferredStyle: UIAlertControllerStyle.Alert)
        alert.addAction(UIAlertAction(title: "Cancel", style: UIAlertActionStyle.Default, handler: nil))
        self.presentViewController(alert, animated: true, completion: nil)
    }
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return self.category == "Issues" ? 3 : 1
    }
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.category == "Issues" ? tableData?.objectAtIndex(section).count ?? 0 : (tableData?.count ?? 0)
    }
    override func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return self.category == "Issues" ? self.issueCategories[section] : ""
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("DataItemCell") as! UITableViewCell
        let row = indexPath.row
        var rowData : NSDictionary
        if (self.category == "Issues") {
            rowData = tableData?.objectAtIndex(indexPath.section).objectAtIndex(row) as! NSDictionary
        } else {
            rowData = (tableData?.objectAtIndex(row) as! NSDictionary)
        }
        if (self.category == "Devices") {
            cell.textLabel?.text = rowData.objectForKey("name") as? String
            cell.detailTextLabel?.text = rowData.objectForKey("os") as? String
        } else if (self.category == "Issues") {
            cell.textLabel?.text = rowData.objectForKey("message") as? String
            cell.detailTextLabel?.text = rowData.objectForKey("device_id") as? String
        } else if (self.category == "Software") {
            cell.textLabel?.text = rowData.objectForKey("name") as? String
            cell.detailTextLabel?.text = rowData.objectForKey("version") as? String
        } else {
            cell.textLabel?.text = rowData.description
        }
        return cell
    }
    
    @IBAction func close(segue: UIStoryboardSegue) {
        println("Closing modal dialog")
    }
    
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
    }
}
