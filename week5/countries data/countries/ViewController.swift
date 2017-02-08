//
//  ViewController.swift
//  countries
//
//  Created by Aileen Pierce
//  Copyright © 2016 Aileen Pierce. All rights reserved.
//

import UIKit

class ViewController: UITableViewController {
    var continentList = Continents()
    let kfilename = "data.plist"

    func getDataFile() -> String? {
        //use a Bundle object of the directory for our application to retrieve the pathname of continents.plist
        guard let pathString = Bundle.main.path(forResource: "continents", ofType: "plist") else {
            return nil
        }
        return pathString
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        let path:String?
        let filePath = docFilePath(kfilename) //path to data file
        //print(filePath)

        //if the data file exists, use it
        if FileManager.default.fileExists(atPath: filePath!){
            path = filePath
            //print(path)
        }
        else {
            path = getDataFile()
        }

        //load the data of the plist file into the dictionary
        continentList.continentData = NSDictionary(contentsOfFile: path!) as! [String : [String]]
        //puts all the continents in an array
        continentList.continents = Array(continentList.continentData.keys)
        
        //application instance
        let app = UIApplication.shared
        //subscribe to the UIApplicationWillResignActiveNotification notification
        NotificationCenter.default.addObserver(self, selector: #selector(UIApplicationDelegate.applicationWillResignActive(_:)), name: NSNotification.Name(rawValue: "UIApplicationWillResignActiveNotification"), object: app)
    }

    override func viewWillAppear(_ animated: Bool) {
        print("view will appear")
    }
    
    @IBAction func preparetounwind(_ segue: UIStoryboardSegue){
        print("unwinding")
    }
    
    //Required methods for UITableViewDataSource
    //Number of rows in the section
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return continentList.continentData.count
    }
    
    // Displays table view cells
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        //configure the cell
        let cell = tableView.dequeueReusableCell(withIdentifier: "CellIdentifier", for: indexPath)
        cell.textLabel?.text = continentList.continents[indexPath.row]
        return cell
    }
    
    //Handles segues to other view controllers
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "countrysegue" {
            let detailVC = segue.destination as! DetailViewController
            let indexPath = tableView.indexPath(for: sender as! UITableViewCell)!
            //sets the data for the destination controller
            detailVC.title = continentList.continents[indexPath.row]
            detailVC.continentListDetail=continentList
            detailVC.selectedContinent = indexPath.row
        } //for detail disclosure 
        else if segue.identifier == "continentsegue"{
            let infoVC = segue.destination as! ContinentInfoTableViewController
            let editingCell = sender as! UITableViewCell
            let indexPath = tableView.indexPath(for: editingCell)
            infoVC.name = continentList.continents[indexPath!.row]
            let countries = continentList.continentData[infoVC.name]! as [String]
            infoVC.number = String(countries.count)
        }
    }
    
    func docFilePath(_ filename: String) -> String?{
        //locate the documents directory
        let path = NSSearchPathForDirectoriesInDomains(FileManager.SearchPathDirectory.documentDirectory, FileManager.SearchPathDomainMask.allDomainsMask, true)
        let dir = path[0] as NSString //document directory
        //print(dir)
        //creates the full path to our data file
        return dir.appendingPathComponent(filename)
    }
    
    //called when the UIApplicationWillResignActiveNotification notification is posted
    //all notification methods take a single NSNotification instance as their argument
    func applicationWillResignActive(_ notification: Notification){
        let filePath = docFilePath(kfilename)
        let data = NSMutableDictionary()
        //adds our whole dictionary to the data dictionary
        data.addEntries(from: continentList.continentData)
        //print(data)
        //write the contents of the array to our plist file
        data.write(toFile: filePath!, atomically: true)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

