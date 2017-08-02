//
//  HONTableView.swift
//  Pods
//
//  Created by Sravan Kumar on 02/08/17.
//
//

import UIKit

public class HONTableView: UIView,UITableViewDelegate,UITableViewDataSource {

    @IBOutlet var heightConstraint: NSLayoutConstraint!
    
    public var menuArray = [String]() {
        didSet{tableView.reloadData()}
    }
    public var selectedItem: String? //Selected item can store when user selected on drop down view

    private var selectedIndexPath: IndexPath = IndexPath(row: -1, section: -1)
    
    //MARK:- intilizers
    override public init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }
    
    lazy var tableView: UITableView = {
        let dropDownTableView = UITableView(frame: .zero)
        dropDownTableView.translatesAutoresizingMaskIntoConstraints = false
        dropDownTableView.tableFooterView = UIView(frame: .zero)
        dropDownTableView.separatorInset = UIEdgeInsetsMake(0, 0, 0, 0)
        dropDownTableView.bounces = false
        return dropDownTableView
    }()

    fileprivate func setup() {
        loadTableView()
    }
    
    /// It loads the tableview on top of the super view and setting constraints
    fileprivate func loadTableView() {
        
        addSubview(tableView)
        
        tableView.delegate = self
        tableView.dataSource = self

        let podBundle = Bundle(for: HONTableView.self)
        tableView.register(HONSwitchTableViewCell.self, forCellReuseIdentifier: "SwitchReuseIdentifier")
        tableView.register(UINib(nibName: "HONSwitchTableViewCell", bundle: podBundle), forCellReuseIdentifier: "SwitchReuseIdentifier")
        
        let leadingC = NSLayoutConstraint(item: tableView, attribute: .leading, relatedBy: .equal, toItem: self, attribute: .leading, multiplier: 1, constant: 0)
        let topC = NSLayoutConstraint(item: tableView, attribute: .top, relatedBy: .equal, toItem: self, attribute: .top, multiplier: 1, constant: 0)
        let bottomC = NSLayoutConstraint(item: tableView, attribute: .bottom, relatedBy: .equal, toItem: self, attribute: .bottom, multiplier: 1, constant: 0)
        let trailingC = NSLayoutConstraint(item: tableView, attribute: .trailing, relatedBy: .equal, toItem: self, attribute: .trailing, multiplier: 1, constant: 0)
        addConstraints([leadingC,bottomC,trailingC,topC])
        
        tableView.layer.borderColor = UIColor(red: 48/255, green: 181/255, blue: 244/255, alpha: 1).cgColor
        tableView.layer.borderWidth = 1.5
    }

    //MARK:- UITableViewDataSource Methods
    
    public func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if selectedIndexPath.section != -1 {
            return menuArray.count
        }
        return 1
    }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "SwitchReuseIdentifier", for: indexPath) as! HONSwitchTableViewCell
        let dataString = selectedIndexPath.section != -1 ? menuArray[indexPath.row] : selectedItem
        cell.lblText.text = dataString
        cell.lblText.textColor = UIColor.white
        cell.backgroundColor = UIColor.black
        cell.selectionStyle = .none
        
        return cell
    }

    public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if selectedIndexPath.section == -1 {
            
            selectedIndexPath = indexPath
            tableView.beginUpdates()
            for i in 1 ..< menuArray.count {
                let nextIndexPath = IndexPath(row: i, section: 0)
                tableView.insertRows(at: [nextIndexPath], with: .top)
            }
            heightConstraint.constant = CGFloat((menuArray.count)*44)
            UIView.animate(withDuration: 0.5, animations: { 
                self.superview?.layoutIfNeeded()
            })
            tableView.endUpdates()
        }else {
            selectedItem = menuArray[indexPath.row]
            selectedIndexPath = IndexPath(row: -1, section: -1)
            tableView.beginUpdates()
            for i in 1 ..< menuArray.count {
                let nextIndexPath = IndexPath(row: i, section: 0)
                tableView.deleteRows(at: [nextIndexPath], with: .fade)
            }
            heightConstraint.constant = 44
            UIView.animate(withDuration: 0.5, animations: {
                self.superview?.layoutIfNeeded()
            }, completion:{(success) in
                self.tableView.endUpdates()
                self.tableView.reloadSections(IndexSet(integer: 0), with: .automatic)
            })
        }
    }
}
