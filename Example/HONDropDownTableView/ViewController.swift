//
//  ViewController.swift
//  HONDropDownTableView
//
//  Created by sravankumar143 on 07/12/2017.
//  Copyright (c) 2017 sravankumar143. All rights reserved.
//

import UIKit
import HONDropDownTableView

class ViewController: UIViewController {

    @IBOutlet weak var customView: HONButtonView!
    @IBOutlet weak var button4: UIButton!
    @IBOutlet weak var honTableView: HONTableView!
    
    var dropDownVc2: HONDropDownTableViewController?
    var dropDownVc4: HONDropDownTableViewController?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view, typically from a nib.
        customUI()
        honTableView.menuArray = ["Recently Computed","ETD","Tail","Filing Status","Departure","Destination","Hidden Flight Plans"]
        honTableView.selectedItem = "Recently Computed"
        
        customView.direction = 2
        //customView.selectArrowImage = UIImage(named: "arrowup")!
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //MARK:- Private Methods
    
    fileprivate func customUI() {
        customizeTableView()
    }
    
    fileprivate func customizeTableView() {
        customView.dropDownTable.separatorColor = UIColor.lightGray
        customView.dropDownTable.backgroundColor = UIColor.black
        customView.dropDownTable.cellSelectionStyle = UITableViewCellSelectionStyle.none
        customView.dropDownTable.separatorStyle = .singleLine
        customView.dropDownTable.cellLblTextColor = UIColor.white
    }
}

