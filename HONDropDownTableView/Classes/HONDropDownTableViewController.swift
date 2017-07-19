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
    public var presentingView: UIView?
    
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
    
    public var cellLblTextColor: UIColor = UIColor.white {
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
    
    public var separatorStyle: UITableViewCellSeparatorStyle = .none {
        willSet {tableView.separatorStyle = newValue}
        didSet {tableViewReloadData()}
    }
    
    public var dropDownLayerColor: CGColor = UIColor(red: 48/255, green: 181/255, blue: 244/255, alpha: 1).cgColor {
        willSet{self.layer.backgroundColor = newValue}
    }
    
    public var lblFont: UIFont = UIFont(name: "Helvetica Neue", size: 16)!
    public var direction = DropDownDirection.bottom.rawValue

    //MARK:- Private Properties
    private var parentView: UIView?
    private var tableViewCellType: Int = CustomCellType.Text.rawValue
    private let dropDownLayerBoaderWidth = 1.5
    private var existParentViewLayerColor: CGColor?
    private var viewHeightConstraint: NSLayoutConstraint!
    private var tableViewHeightConstraint: NSLayoutConstraint!
    private dynamic var cellHeight = 36 {
        willSet { tableView.rowHeight = CGFloat(newValue) }
        didSet { tableViewReloadData() }
    }
    
    //MARK:- Class Enums
    public enum CustomCellType: Int {
        case Text = 1   //It loads text based Custom View (HONSwitchTableViewCell)
        case TextImage      //It loads text and image based custom view (HONValue1TableViewCell)
    }
    
    public enum DropDownDirection: Int {
        case top = 1
        case bottom
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
    public init(withFrame: CGRect, parentView: UIView, cellStyle: CustomCellType) {
        self.init()
        self.parentView = parentView
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
        self.layer.borderColor = dropDownLayerColor
        self.layer.borderWidth = 2
        self.layer.masksToBounds = true
        
        addSubview(tableView)
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.layer.cornerRadius = 5.0
        
        
        let leadingC = NSLayoutConstraint(item: tableView, attribute: .leading, relatedBy: .equal, toItem: self, attribute: .leading, multiplier: 1, constant: 0)
        let topC = NSLayoutConstraint(item: tableView, attribute: .top, relatedBy: .equal, toItem: self, attribute: .top, multiplier: 1, constant: 0)
       // let bottomC = NSLayoutConstraint(item: self, attribute: .bottom, relatedBy: .equal, toItem: tableView, attribute: .bottom, multiplier: 1, constant: 0)
        let trailingC = NSLayoutConstraint(item: self, attribute: .trailing, relatedBy: .equal, toItem: tableView, attribute: .trailing, multiplier: 1, constant: 0)
        tableViewHeightConstraint = NSLayoutConstraint(item: tableView, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .height, multiplier: 1, constant: viewHeightConstraint.constant)
        addConstraints([leadingC,tableViewHeightConstraint,trailingC,topC])
    }
    
    public func show() {
        existParentViewLayerColor = parentView?.layer.borderColor
        parentView?.layer.borderColor = dropDownLayerColor
        parentView?.layer.borderWidth = CGFloat(dropDownLayerBoaderWidth)
        parentView?.layer.masksToBounds = true
        
        self.translatesAutoresizingMaskIntoConstraints = false

        let leadingConstraint = NSLayoutConstraint(item: parentView!, attribute: .leading, relatedBy: .equal, toItem: self, attribute: .leading, multiplier: 1, constant: 0)
        var topConstraint = NSLayoutConstraint(item: self, attribute: .top, relatedBy: .equal, toItem: parentView!, attribute: .top, multiplier: 1, constant: parentView!.frame.size.height)
        let trailingConstraint = NSLayoutConstraint(item: self, attribute: .trailing, relatedBy: .equal, toItem: parentView!, attribute: .trailing, multiplier: 1, constant: 0)
        viewHeightConstraint = NSLayoutConstraint(item: self, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .height, multiplier: 1, constant: 0)
        
        if DropDownDirection.top.rawValue == direction {
            topConstraint = NSLayoutConstraint(item: self, attribute: .bottom, relatedBy: .equal, toItem: parentView!, attribute: .top, multiplier: 1, constant:0)
        }
      
        if let parentContr = self.presentingView {
            parentContr.addSubview(self)
            parentContr.bringSubview(toFront: self)
            
            parentContr.addConstraints([leadingConstraint, trailingConstraint, topConstraint, viewHeightConstraint])
        }else {
            let visibleWindow = UIWindow.visibleWindow()
            visibleWindow?.addSubview(self)
            visibleWindow?.bringSubview(toFront: self)
            
            visibleWindow?.addConstraints([leadingConstraint, trailingConstraint, topConstraint, viewHeightConstraint])
        }
        
        
        loadTableView()
        perform(#selector(self.showAnimation), with: self, afterDelay: 0.3)
        
    }
    
    @objc private func showAnimation() {
    
        UIView.animate(withDuration: 0.5, delay: 0.0, options: UIViewAnimationOptions.transitionCrossDissolve, animations: {
            
            self.viewHeightConstraint.constant = 200
            self.tableViewHeightConstraint.constant = 200
            self.setNeedsLayout()
            self.layoutIfNeeded()
        })
    }
    
    public func hideDropDown() {
        if let layerColor = existParentViewLayerColor {
            parentView?.layer.borderColor = layerColor
        }
        tableView.removeFromSuperview()
        UIView.animate(withDuration: 0.5) { 
            self.removeFromSuperview()
        }
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

internal extension UIWindow {
    
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
}

