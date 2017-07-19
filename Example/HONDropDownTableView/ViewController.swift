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

    @IBOutlet weak var button0: UIButton!
    @IBOutlet weak var button1: UIButton!
    @IBOutlet weak var button2: UIButton!
    @IBOutlet weak var button3: UIButton!
    @IBOutlet weak var button4: UIButton!
    @IBOutlet weak var button5: UIButton!

    
    var dropDownVc0: HONDropDownTableViewController!
    var dropDownVc1: HONDropDownTableViewController!
    var dropDownVc2: HONDropDownTableViewController!
    var dropDownVc3: HONDropDownTableViewController!
    var dropDownVc4: HONDropDownTableViewController!
    var dropDownVc5: HONDropDownTableViewController!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view, typically from a nib.
        customUI()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //MARK:- HONDropDownTableViewControllerProtocol
    func didSelectTableViewTapped(index: Int) {
        print("Selected IndexPath: \(index)")
    }
    
    //MARK:- Private Methods
    
    fileprivate func customUI() {
        button1.layer.borderColor = UIColor.lightGray.cgColor
        button1.layer.borderWidth = 1.5
    }
    
    @IBAction func button0Tapped(sender: UIButton) {
        
        if dropDownVc0 == nil {
            dropDownVc0 = HONDropDownTableViewController(withFrame: CGRect.zero, parentView: sender, cellStyle: HONDropDownTableViewController.CustomCellType(rawValue: 1)!)
        }
        dropDownVc0.dropDownDelegate = self
        dropDownVc0.dataSourceArray = ["Cell 1","Cell 2","Cell 3","Cell 4","Cell 5","Cell 6"]
    
        customizeTableView(tableViewController: dropDownVc0)

        dropDownVc0.show()
    }
    
    @IBAction func button1Tapped(sender: UIButton) {
        
        if dropDownVc1 == nil {
            dropDownVc1 = HONDropDownTableViewController(withFrame: CGRect.zero, parentView: sender, cellStyle: HONDropDownTableViewController.CustomCellType(rawValue: 1)!)
        }
  
        if !sender.isSelected {
            dropDownVc1.dropDownDelegate = self
            dropDownVc1.dataSourceArray = ["Cell 1","Cell 2","Cell 3","Cell 4","Cell 5","Cell 6"]
            customizeTableView(tableViewController: dropDownVc1)
            sender.isSelected = !sender.isSelected
            
            dropDownVc1.show()
        }else {
            sender.isSelected = !sender.isSelected
            dropDownVc1.hideDropDown()
            dropDownVc1 = nil
        }
    }
    
    @IBAction func button2Tapped(sender: UIButton) {
        if dropDownVc2 == nil {
            dropDownVc2 = HONDropDownTableViewController(withFrame: CGRect.zero, parentView: sender, cellStyle: HONDropDownTableViewController.CustomCellType(rawValue: 1)!)
        }
        dropDownVc2.dropDownDelegate = self
        dropDownVc2.dataSourceArray = ["Cell 1","Cell 2","Cell 3","Cell 4","Cell 5","Cell 6"]

        dropDownVc2.show()
    }
    
    @IBAction func button3Tapped(sender: UIButton) {
        if dropDownVc3 == nil {
            dropDownVc3 = HONDropDownTableViewController(withFrame: CGRect.zero, parentView: sender, cellStyle: HONDropDownTableViewController.CustomCellType(rawValue: 1)!)
        }
        dropDownVc3.dropDownDelegate = self
        dropDownVc3.dataSourceArray = ["Cell 1","Cell 2","Cell 3","Cell 4","Cell 5","Cell 6"]
        customizeTableView(tableViewController: dropDownVc3)
        
        dropDownVc3.show()
    }
    
    @IBAction func button4Tapped(sender: UIButton) {
        if dropDownVc4 == nil {
            dropDownVc4 = HONDropDownTableViewController(withFrame: CGRect.zero, parentView: sender, cellStyle: HONDropDownTableViewController.CustomCellType(rawValue: 1)!)
        }
        dropDownVc4.dropDownDelegate = self
        dropDownVc4.dataSourceArray = ["Cell 1","Cell 2","Cell 3","Cell 4","Cell 5","Cell 6"]
        customizeTableView(tableViewController: dropDownVc4)
        dropDownVc4.direction = 1

        dropDownVc4.show()
    }
    
    @IBAction func button5Tapped(sender: UIButton) {
        
        let vc = HONDropDownTableViewController(withFrame: CGRect.zero, parentView: sender, cellStyle: HONDropDownTableViewController.CustomCellType(rawValue: 1)!)
        vc.dropDownDelegate = self
        vc.dataSourceArray = ["Cell 1","Cell 2","Cell 3","Cell 4","Cell 5","Cell 6"]
        customizeTableView(tableViewController: vc)
        vc.direction = 1
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

