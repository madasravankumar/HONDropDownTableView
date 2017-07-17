//
//  HONDropDownTableViewController.swift
//  Pods
//
//  Created by Sravan Kumar on 12/07/17.
//
//

import UIKit

public protocol HONDropDownTableViewControllerProtocol {
    func didSelectTableViewTapped(index: Int)
}

public typealias DidSelectTableViewRowClosure = (_ index: Int) -> Void

public class HONDropDownTableViewController: UIViewController,UITableViewDataSource,UITableViewDelegate {

    public var dataSourceArray: [String]?
    public var dropDownDelegate: HONDropDownTableViewControllerProtocol?
    public var separatorColor: UIColor = UIColor.lightGray
    public var parentController: UIViewController?
    public var cellBackgroundColor: UIColor?
    public var didSelectedRow: DidSelectTableViewRowClosure?
    public var cellSelectionStyle: UITableViewCellSelectionStyle = .none
    
    var tableViewCellType: Int = CustomCellType.Text.hashValue
    
    public enum CustomCellType {
        case Text   //It loads text based Custom View (HONSwitchTableViewCell)
        case TextImage      //It loads text and image based custom view (HONValue1TableViewCell)
    }
    
    struct CellReuseIdetifers {
        let cellReuseIdentifier = "SwitchReuseIdentifier"
        let value1ReuseIdentifier = "Value1TableViewCell"
    }
    
    /// it changes the table view background color
    public var tableViewBackgroundColor: UIColor {
        set {
            self.tableView.backgroundColor = newValue
        }
        get {
            return self.tableView.backgroundColor!
        }
    }
    
    lazy var tableView: UITableView = {
        let dropDownTableView = UITableView(frame: .zero)
        dropDownTableView.translatesAutoresizingMaskIntoConstraints = false
        dropDownTableView.backgroundColor = UIColor.black
        dropDownTableView.tableFooterView = UIView(frame: .zero)
        dropDownTableView.separatorStyle = .none
    
        return dropDownTableView
    }()
    
    //MARK:- Intilizers
    
    public override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }
    
    public init(withFrame: CGRect, parentController: UIViewController, cellStyle: CustomCellType) {
        self.init()
        self.parentController = parentController
        self.parentController?.addChildViewController(self)
        self.didMove(toParentViewController: self.parentController)
        //view.frame = withFrame
        setup(cellStyle: cellStyle)
    }

    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK:- View Life Cycle
    
    override public func viewDidLoad() {
        super.viewDidLoad()
        loadTableView()
    }

    override public func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    //MARK:- Private Methods
    fileprivate func setup(cellStyle: CustomCellType) {
        cellBackgroundColor = UIColor.clear
        separatorColor = UIColor.lightGray
        tableView.backgroundColor = UIColor.black
        tableViewCellType = cellStyle.hashValue

        let podBundle = Bundle(for: HONDropDownTableViewController.self)

        if cellStyle == .Text {
            tableView.register(HONSwitchTableViewCell.self, forCellReuseIdentifier: CellReuseIdetifers().cellReuseIdentifier)
            tableView.register(UINib(nibName: "SwitchTableViewCell", bundle: podBundle), forCellReuseIdentifier: CellReuseIdetifers().cellReuseIdentifier)
        }else if cellStyle == .TextImage {
            tableView.register(HONValue1TableViewCell.self, forCellReuseIdentifier: CellReuseIdetifers().value1ReuseIdentifier)
            tableView.register(UINib(nibName: "Value1TableViewCell", bundle: podBundle), forCellReuseIdentifier: CellReuseIdetifers().value1ReuseIdentifier)
        }
    }
    
    /// This method can be used to reload the data from parent class
    public func tableViewReloadData() {
        tableView.reloadData()
    }
    
     /// It loads the tableview on top of the super view and setting constraints
     fileprivate func loadTableView() {
        
        view.addSubview(tableView)
        
        tableView.delegate = self
        tableView.dataSource = self
        
        let leadingC = NSLayoutConstraint(item: tableView, attribute: .leading, relatedBy: .equal, toItem: self.view, attribute: .leading, multiplier: 1, constant: 0)
        let topC = NSLayoutConstraint(item: tableView, attribute: .top, relatedBy: .equal, toItem: self.view, attribute: .top, multiplier: 1, constant: 0)
        let bottomC = NSLayoutConstraint(item: self.view, attribute: .bottom, relatedBy: .equal, toItem: tableView, attribute: .bottom, multiplier: 1, constant: 0)
        let trailingC = NSLayoutConstraint(item: self.view, attribute: .trailing, relatedBy: .equal, toItem: tableView, attribute: .trailing, multiplier: 1, constant: 0)
        
        view.addConstraints([leadingC,trailingC,bottomC,topC])
    }
    
    //MARK:- UITableViewDataSource Methods
    
    public func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let count = dataSourceArray?.count {
            return count
        }
        return 0
    }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if tableViewCellType == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: CellReuseIdetifers().cellReuseIdentifier, for: indexPath) as! HONSwitchTableViewCell
            cell.lblText.text = dataSourceArray?[indexPath.row]
            cell.lblLine.backgroundColor = separatorColor
            cell.selectionStyle = cellSelectionStyle
            return cell
        }else {
            let cell = tableView.dequeueReusableCell(withIdentifier: CellReuseIdetifers().value1ReuseIdentifier, for: indexPath) as! HONValue1TableViewCell
            cell.lblTitle.text = dataSourceArray?[indexPath.row]
           // cell.lblLine.backgroundColor = separatorColor
            cell.selectionStyle = cellSelectionStyle
            return cell
        }
    }
    
    public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if  let dropDelegate = dropDownDelegate?.didSelectTableViewTapped(index: indexPath.row) {
            dropDelegate
        }
        
        if let closureDelegate = didSelectedRow?(indexPath.row) {
            return closureDelegate
        }
    }
}
