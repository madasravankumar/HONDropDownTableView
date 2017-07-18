//
//  ViewController.swift
//  HONDropDownTableView
//
//  Created by sravankumar143 on 07/12/2017.
//  Copyright (c) 2017 sravankumar143. All rights reserved.
//

import UIKit
import HONDropDownTableView

class ViewController: UIViewController,HONDropDownTableViewControllerProtocol {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view, typically from a nib.
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //MARK:- HONDropDownTableViewControllerProtocol
    func didSelectTableViewTapped(index: Int) {
        print("Selected IndexPath: \(index)")
    }
    
    @IBAction func buttonTapped(sender: UIButton) {
        
        let vc = HONDropDownTableViewController(withFrame: CGRect.zero, parentController: sender, cellStyle: HONDropDownTableViewController.CustomCellType(rawValue: 1)!)
        vc.dropDownDelegate = self
        vc.dataSourceArray = ["Cell 1","Cell 2"]
        customizeTableView(tableViewController: vc)

        vc.show()
    }
    
    fileprivate func customizeTableView(tableViewController: HONDropDownTableViewController) {
        tableViewController.separatorColor = UIColor.lightGray
        tableViewController.backgroundColor = UIColor.black
        tableViewController.cellSelectionStyle = UITableViewCellSelectionStyle.none
        tableViewController.separatorStyle = .singleLine
        tableViewController.cellLblTextColor = UIColor.white
    }
}

