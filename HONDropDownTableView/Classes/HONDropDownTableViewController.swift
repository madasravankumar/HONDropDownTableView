//
//  HONDropDownTableViewController.swift
//  Pods
//
//  Created by Sravan Kumar on 12/07/17.
//
//

import UIKit


public class HONDropDownTableViewController: UITableViewController {

    var dataSourceArray: [AnyObject]?
    let cellReuseIdentifier = "SwitchReuseIdentifier"

    override public func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
        dataSourceArray = ["Cell-1" as AnyObject,"Cell 2" as AnyObject,"Cell 3" as AnyObject]
        registerNibs()
    }

    override public func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

     fileprivate func registerNibs() {
        tableView.register(SwitchTableViewCell.self, forCellReuseIdentifier: cellReuseIdentifier)
        let podBundle = Bundle(for: HONDropDownTableViewController.self)
        tableView.register(UINib(nibName: "SwitchTableViewCell", bundle: podBundle), forCellReuseIdentifier: cellReuseIdentifier)

//        if let bundleURL = podBundle.url(forResource: "HONDropDownTableView", withExtension: "bundle") {
//            if let bundle = Bundle.init(url: bundleURL) {
//                tableView.register(UINib(nibName: "SwitchTableViewCell", bundle: bundle), forCellReuseIdentifier: cellReuseIdentifier)
//            }else {
//                assertionFailure("Could not load the bundle")
//            }
//        }else {
//            assertionFailure("Could not create a path to the bundle")
//        }
    }
    
    
    // MARK: - Table view data source

    override public func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        let defaultRows = 0
        if let count = dataSourceArray?.count {
            return count
        }
        return defaultRows
    }

    
    override public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellReuseIdentifier, for: indexPath) as! SwitchTableViewCell
        let object = dataSourceArray?[indexPath.row] as! String
        cell.lblCell.text = object

        // Configure the cell...

        return cell
    }
    

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
