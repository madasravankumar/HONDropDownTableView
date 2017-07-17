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
        
     /*   let vc = HONDropDownTableViewController(withFrame: CGRect(x: 100, y: 100, width: 200, height: 200), parentController: self)
        vc.dropDownDelegate = self
        vc.dataSourceArray = ["Cell 1","Cell 2"]
        vc.separatorColor = UIColor.lightGray
        vc.tableViewBackgroundColor = UIColor.black
        
        //vc.didSelectedRow = { (index) in
//            print(index)
//        }
        view.addSubview(vc.view)*/
        
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
        
        let vc = HONDropDownTableViewController(withFrame: CGRect.zero, parentController: self, cellStyle: .Text)
        vc.view.translatesAutoresizingMaskIntoConstraints = false
        vc.dropDownDelegate = self
        vc.dataSourceArray = ["Cell 1","Cell 2"]
        customizeTableView(tableViewController: vc)
        view.addSubview(vc.view)

        //vc.didSelectedRow = { (index) in
        //            print(index)
        //        }
  
        let leadingConstraint = NSLayoutConstraint(item: sender, attribute: .leading, relatedBy: .equal, toItem: vc.view, attribute: .leading, multiplier: 1, constant: 0)
        var topConstraint = NSLayoutConstraint(item: vc.view, attribute: .top, relatedBy: .equal, toItem: sender, attribute: .top, multiplier: 1, constant: sender.frame.size.height + 5)
        let trailingConstraint = NSLayoutConstraint(item: vc.view, attribute: .trailing, relatedBy: .equal, toItem: sender, attribute: .trailing, multiplier: 1, constant: 0)
        let heightConstraint = NSLayoutConstraint(item: vc.view, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .height, multiplier: 1, constant: 100)
        
        if sender.tag == 4 || sender.tag == 5 {
            topConstraint = NSLayoutConstraint(item: vc.view, attribute: .bottom, relatedBy: .equal, toItem: sender, attribute: .top, multiplier: 1, constant: 5)
        }
        view.addConstraints([leadingConstraint, trailingConstraint, topConstraint, heightConstraint])
    }
    
    fileprivate func customizeTableView(tableViewController: HONDropDownTableViewController) {
        tableViewController.separatorColor = UIColor.lightGray
        tableViewController.tableViewBackgroundColor = UIColor.black

    }
}

