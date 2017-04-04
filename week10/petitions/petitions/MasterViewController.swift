//
//  MasterViewController.swift
//  petitions
//
//  Created by Aileen Pierce
//  Copyright © 2016 Aileen Pierce. All rights reserved.
//

import UIKit

class MasterViewController: UITableViewController {

    var detailViewController: DetailViewController? = nil
    var objects = [[String:String]]()


    override func viewDidLoad() {
        super.viewDidLoad()
        loadjson()
    }

    func loadjson(){
        let urlPath = "https://api.whitehouse.gov/v1/petitions.json?limit=50"
        guard let url = URL(string: urlPath)
            else {
                print("url error")
                return
            }

        let session = URLSession.shared.dataTask(with: url, completionHandler: {(data, response, error) in
            let httpResponse = response as! HTTPURLResponse
            let statusCode = httpResponse.statusCode
            /*
            if (statusCode == 200){
                //download successful
                dispatch_async(dispatch_get_main_queue()) {self.parsejson(data!)}
            }
            else {
                print("file download error")
            }
            */
            guard statusCode == 200
                else {
                    print("file download error")
                    return
            }
            //download successful
            print("download complete")
            DispatchQueue.main.async {self.parsejson(data!)}
        })
        //must call resume to run session
        session.resume()
    }
    
    func parsejson(_ data: Data){
        do {
            // get json data
            let json = try JSONSerialization.jsonObject(with: data, options: JSONSerialization.ReadingOptions.allowFragments) as! NSDictionary
            //get all results
            let allresults = json["results"] as! [[String:Any]]

            //add results to objects
            for result in allresults {
                //check that data exists
                guard let title = result["title"]! as? String,
                    let sigCount = result["signatureCount"] as? NSNumber,
                    let itemurl = result["url"]!as? String
                    else {
                        continue
                    }
                //create new object
                let obj = ["title": title, "signature": sigCount.stringValue, "url": itemurl]
                //add object to array
                self.objects.append(obj)
            }
        //handle thrown error
        } catch {
            print("Error with JSON: \(error)")
            return
        }
        //reload the table data after the json data has been downloaded
        tableView.reloadData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.clearsSelectionOnViewWillAppear = self.splitViewController!.isCollapsed
        super.viewWillAppear(animated)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


    // MARK: - Segues

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showDetail" {
            if let indexPath = self.tableView.indexPathForSelectedRow {
                let petition = objects[indexPath.row]
                let title = petition["title"]
                let url = petition["url"]
                let controller = (segue.destination as! UINavigationController).topViewController as! DetailViewController
                controller.detailItem = url
                controller.title = title
                controller.navigationItem.leftBarButtonItem = self.splitViewController?.displayModeButtonItem
                controller.navigationItem.leftItemsSupplementBackButton = true
            }
        }
    }

    // MARK: - Table View

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return objects.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        
        let object = objects[indexPath.row]
        cell.textLabel!.text = object["title"]
        if object["signature"] != nil {
            cell.detailTextLabel!.text = object["signature"]! + " signatures"
        }
        return cell
    }

/*
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }

    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            objects.removeAtIndex(indexPath.row)
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
        } else if editingStyle == .Insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view.
        }
    }
*/

}
