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

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        let vc = HONDropDownTableViewController(style: UITableViewStyle.plain)
        vc.view.frame = CGRect(x: 100, y: 100, width: 200, height: 200)
        view.addSubview(vc.view)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}

