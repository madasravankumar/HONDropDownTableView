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

public class HONDropDownTableViewController: UIView, UITableViewDataSource,UITableViewDelegate {
    
    public var dropDownDelegate: HONDropDownTableViewControllerProtocol?
    public var didSelectedRow: DidSelectTableViewRowClosure?

    public var dataSourceArray = [String]() {
        didSet{tableViewReloadData()}
    }
    
    public var separatorColor: UIColor = UIColor.lightGray {
        willSet{self.tableView.separatorColor = newValue}
        didSet{tableViewReloadData()}
    }
    
    public var cellBackgroundColor: UIColor = UIColor.clear {
        didSet{tableViewReloadData()}
    }
    
    public var cellSelectionStyle: UITableViewCellSelectionStyle = .none {
        didSet{tableViewReloadData()}
    }
    
    public var cellLblTextColor: UIColor = UIColor.black {
        didSet{tableViewReloadData()}
    }
    
    /// it changes the table view background color
    fileprivate var tableViewBackgroundColor: UIColor = UIColor.black {
        willSet {self.tableView.backgroundColor = newValue}
    }
    
    public override var backgroundColor: UIColor? {
        set {tableViewBackgroundColor = newValue!}
        get {return tableViewBackgroundColor}
    }
    
    public dynamic var cellHeight = 44 {
        willSet { tableView.rowHeight = CGFloat(newValue) }
        didSet { tableViewReloadData() }
    }
    
    public var separatorStyle: UITableViewCellSeparatorStyle = .none {
        willSet {tableView.separatorStyle = newValue}
        didSet {tableViewReloadData()}
    }
    
    public var lblFont: UIFont = UIFont(name: "Helvetica Neue", size: 16)!
    
    private var parentView: UIView?
    private var tableViewCellType: Int = CustomCellType.Text.rawValue
    
    public enum CustomCellType: Int {
        case Text = 1   //It loads text based Custom View (HONSwitchTableViewCell)
        case TextImage      //It loads text and image based custom view (HONValue1TableViewCell)
    }
    
    struct CellReuseIdetifers {
        let cellReuseIdentifier = "SwitchReuseIdentifier"
        let value1ReuseIdentifier = "Value1TableViewCell"
    }

    lazy var tableView: UITableView = {
        let dropDownTableView = UITableView(frame: .zero)
        dropDownTableView.translatesAutoresizingMaskIntoConstraints = false
        dropDownTableView.backgroundColor = UIColor.black
        dropDownTableView.tableFooterView = UIView(frame: .zero)
        dropDownTableView.separatorInset = UIEdgeInsetsMake(0, 0, 0, 0)
        return dropDownTableView
    }()
    
    //MARK:- Intilizers
    
  /*  public override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }*/
    
    override public init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    
    /// This method intilizes the drop down table view controller
    ///
    /// - Parameters:
    ///   - withFrame: frame of the table view
    ///   - parentController: parent view controller to show the tabel view
    ///   - cellStyle: pass the different types of styles.
    public init(withFrame: CGRect, parentController: UIView, cellStyle: CustomCellType) {
        self.init()
        self.parentView = parentController
        setup(cellStyle: cellStyle)
    }

    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK:- View Life Cycle
    
   /* override public func viewDidLoad() {
        super.viewDidLoad()
        loadTableView()
    }

    override public func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }*/

    //MARK:- Private Methods
    fileprivate func setup(cellStyle: CustomCellType) {
        
        tableViewCellType = cellStyle.rawValue

        let podBundle = Bundle(for: HONDropDownTableViewController.self)

        if cellStyle == .Text {
            tableView.register(HONSwitchTableViewCell.self, forCellReuseIdentifier: CellReuseIdetifers().cellReuseIdentifier)
            tableView.register(UINib(nibName: "HONSwitchTableViewCell", bundle: podBundle), forCellReuseIdentifier: CellReuseIdetifers().cellReuseIdentifier)
        }
    }
    
    /// This method can be used to reload the data from parent class
    public func tableViewReloadData() {
        tableView.reloadData()
    }
    
     /// It loads the tableview on top of the super view and setting constraints
     fileprivate func loadTableView() {
        
        addSubview(tableView)
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.layer.cornerRadius = 5.0
        
        let leadingC = NSLayoutConstraint(item: tableView, attribute: .leading, relatedBy: .equal, toItem: self, attribute: .leading, multiplier: 1, constant: 0)
        let topC = NSLayoutConstraint(item: tableView, attribute: .top, relatedBy: .equal, toItem: self, attribute: .top, multiplier: 1, constant: 0)
        let bottomC = NSLayoutConstraint(item: self, attribute: .bottom, relatedBy: .equal, toItem: tableView, attribute: .bottom, multiplier: 1, constant: 0)
        let trailingC = NSLayoutConstraint(item: self, attribute: .trailing, relatedBy: .equal, toItem: tableView, attribute: .trailing, multiplier: 1, constant: 0)
        
        addConstraints([leadingC,trailingC,bottomC,topC])
    }
    
    public func show() {
        
        self.translatesAutoresizingMaskIntoConstraints = false

        let leadingConstraint = NSLayoutConstraint(item: parentView!, attribute: .leading, relatedBy: .equal, toItem: self, attribute: .leading, multiplier: 1, constant: 0)
        var topConstraint = NSLayoutConstraint(item: self, attribute: .top, relatedBy: .equal, toItem: parentView!, attribute: .top, multiplier: 1, constant: parentView!.frame.size.height + 5)
        let trailingConstraint = NSLayoutConstraint(item: self, attribute: .trailing, relatedBy: .equal, toItem: parentView!, attribute: .trailing, multiplier: 1, constant: 0)
        let heightConstraint = NSLayoutConstraint(item: self, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .height, multiplier: 1, constant: 100)
        
        if parentView!.tag == 4 || parentView!.tag == 5 {
            topConstraint = NSLayoutConstraint(item: self, attribute: .bottom, relatedBy: .equal, toItem: parentView!, attribute: .top, multiplier: 1, constant: 5)
        }
        
        let visibleWindow = UIWindow.visibleWindow()
        visibleWindow?.addSubview(self)
        visibleWindow?.bringSubview(toFront: self)
       
        visibleWindow?.addConstraints([leadingConstraint, trailingConstraint, topConstraint, heightConstraint])

        //self.translatesAutoresizingMaskIntoConstraints = false
        //visibleWindow?.addUniversalConstraints(format: "|[dropDown]|", views: ["dropDown": self])
        
        loadTableView()

    }
    
    //MARK:- UITableViewDataSource Methods
    
    public func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataSourceArray.count
    }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if tableViewCellType == 1 {
            let cell = tableView.dequeueReusableCell(withIdentifier: CellReuseIdetifers().cellReuseIdentifier, for: indexPath) as! HONSwitchTableViewCell
            cell.lblText.text = dataSourceArray[indexPath.row]
            cell.selectionStyle = cellSelectionStyle
            cell.backgroundColor = cellBackgroundColor
            cell.lblText.font = lblFont
            cell.lblText.textColor = cellLblTextColor
            return cell
        }
        return UITableViewCell()
    }
    
    public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if  let dropDelegate = dropDownDelegate?.didSelectTableViewTapped(index: indexPath.row) {
            dropDelegate
        }
        
        if let closureDelegate = didSelectedRow?(indexPath.row) {
            return closureDelegate
        }
    }
    
    public func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return CGFloat(cellHeight)
    }
}

public extension UIWindow {
    
    static func visibleWindow() -> UIWindow? {
        var currentWindow = UIApplication.shared.keyWindow
        
        if currentWindow == nil {
            let frontToBackWindows = Array(UIApplication.shared.windows.reversed())
            
            for window in frontToBackWindows {
                if window.windowLevel == UIWindowLevelNormal {
                    currentWindow = window
                    break
                }
            }
        }
        
        return currentWindow
    }
}

internal extension UIView {
    
    var windowFrame: CGRect? {
        return superview?.convert(frame, to: nil)
    }
    
    func addConstraints(format: String, options: NSLayoutFormatOptions = [], metrics: [String: AnyObject]? = nil, views: [String: UIView]) {
        addConstraints(NSLayoutConstraint.constraints(withVisualFormat: format, options: options, metrics: metrics, views: views))
    }
    
    func addUniversalConstraints(format: String, options: NSLayoutFormatOptions = [], metrics: [String: AnyObject]? = nil, views: [String: UIView]) {
        addConstraints(format: "H:\(format)", options: options, metrics: metrics, views: views)
        addConstraints(format: "V:\(format)", options: options, metrics: metrics, views: views)
    }
}

