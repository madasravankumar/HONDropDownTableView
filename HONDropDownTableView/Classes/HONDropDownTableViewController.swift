//
//  HONDropDownTableViewController.swift
//  Pods
//
//  Created by Sravan Kumar on 12/07/17.
//
//

import UIKit

public enum DropDownDirection: Int {
    case top = 1
    case bottom
}


/// Create protocol class for actions on the tableview.
public protocol HONDropDownTableViewControllerProtocol {
    func didSelectTableViewTapped(index: Int, selectedMenu: String, dropDown: HONDropDownTableViewController)
    func didDismissTableViewController(dropDown: HONDropDownTableViewController)
}

/// Closure declaration.
public typealias DidSelectTableViewRowClosure = (_ index: Int) -> Void

/// Class Implementation
public class HONDropDownTableViewController: UIView, UITableViewDataSource,UITableViewDelegate {
    
    //MARK:- Public Variables
    
    public var dropDownDelegate: HONDropDownTableViewControllerProtocol?
    public var didSelectedRow: DidSelectTableViewRowClosure?
  
    /// If user wants to present drop down menu rather than window object he can pass the presenting view.
    public var presentingView: UIView?
    
    /// Selected item can store when user selected on drop down view
    public var selectedItem: String?
    
    ///set the list of data to show on the tableview as menu.
    public var dataSourceArray = [String]() {
        didSet{tableViewReloadData()}
    }
    
    /// Change the separator color of the table in runtime.
    public var separatorColor: UIColor = UIColor(red: 208/255, green: 208/255, blue: 208/255, alpha: 1) {
        willSet{self.tableView.separatorColor = newValue}
        didSet{tableViewReloadData()}
    }
    
    /// change the uitableviewcell background color of the tableview in runtime.
    public var cellBackgroundColor: UIColor = UIColor.clear {
        didSet{tableViewReloadData()}
    }
    
    public var cellSelectionStyle: UITableViewCellSelectionStyle = .none {
        didSet{tableViewReloadData()}
    }   // change the uitableviewcell selection style of the tableview in runtime.
    
    /// change the uitableviewcell title lable color of the tableview in runtime.
    public var cellLblTextColor: UIColor = UIColor(red: 208/255, green: 208/255, blue: 208/255, alpha: 1) {
        didSet{tableViewReloadData()}
    }
    /// it changes the table view background color
    fileprivate var tableViewBackgroundColor: UIColor = UIColor.black {
        willSet {self.tableView.backgroundColor = newValue}
    }
    
    /// Changes the tableview background color.
    public override var backgroundColor: UIColor? {
        set {tableViewBackgroundColor = newValue!}
        get {return tableViewBackgroundColor}
    }
    
    /// changes the separator style of the tableview in runtime.
    public var separatorStyle: UITableViewCellSeparatorStyle = .none {
        willSet {tableView.separatorStyle = newValue}
        didSet {tableViewReloadData()}
    }
    
    /// this method can changes the layer color of the table.
    public var dropDownLayerColor: UIColor = UIColor(red: 48/255, green: 181/255, blue: 244/255, alpha: 1) {
        willSet{self.layer.backgroundColor = newValue.cgColor}
    }
    
    public var isDropDownMenuPresent: Bool {
        get {
            return isViewShowing
        }
    }
    
    public var lblFont: UIFont = UIFont(name: "Helvetica Neue", size: 16)!
    public var direction = DropDownDirection.bottom.rawValue

    //MARK:- Private Properties
    private var disableView: UIView = UIView()
    private var parentView: UIView?
    private var tableViewCellType: Int = CustomCellType.Text.rawValue
    private let dropDownLayerBoaderWidth = 1.5
    private var existParentViewLayerColor: CGColor?
    private var viewBottomConstraint: NSLayoutConstraint!
    private var isViewShowing: Bool = false
    private dynamic var cellHeight = 36 {
        willSet { tableView.rowHeight = CGFloat(newValue) }
        didSet { tableViewReloadData() }
    }
    
    //MARK:- Class Enums
    public enum CustomCellType: Int {
        case Text = 1   //It loads text based Custom View (HONSwitchTableViewCell)
//        case TextImage      //It loads text and image based custom view (HONValue1TableViewCell)
    }
    
    /// it shows the list of cell reuse identifiers for the tableview.
    struct CellReuseIdetifers {
        let cellReuseIdentifier = "SwitchReuseIdentifier"
        let value1ReuseIdentifier = "Value1TableViewCell"
    }

    // creates the tableview in lazy manner
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
    }
    
    //MARK:- Private Methods.
    
    /// this method can be used to initiate the default values and creates the appropriate components
    ///
    /// - Parameter cellStyle: type of the cell which we can shown on tableview.
    fileprivate func setup(cellStyle: CustomCellType) {
        
        self.translatesAutoresizingMaskIntoConstraints = false
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
    
    /// this method can be used to add nslayout constraints to the uiview and table view.
    fileprivate func loadUIView() {
        
        disableViewCreate()

        let leadingConstraint = NSLayoutConstraint(item: parentView!, attribute: .leading, relatedBy: .equal, toItem: self, attribute: .leading, multiplier: 1, constant: 0)
        var topConstraint = NSLayoutConstraint(item: parentView!, attribute: .bottom, relatedBy: .equal, toItem: self, attribute: .top, multiplier: 1, constant: CGFloat(dropDownLayerBoaderWidth))
        let trailingConstraint = NSLayoutConstraint(item: parentView!, attribute: .trailing, relatedBy: .equal, toItem: self, attribute: .trailing, multiplier: 1, constant: 0)
        viewBottomConstraint = NSLayoutConstraint(item: self, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .height, multiplier: 1, constant: 0)

        if DropDownDirection.top.rawValue == direction {
            topConstraint = NSLayoutConstraint(item: parentView!, attribute: .top, relatedBy: .equal, toItem: self, attribute: .bottom, multiplier: 1, constant:-(CGFloat)(dropDownLayerBoaderWidth))
        }
        
        if let parentContr = self.presentingView {
            parentContr.addSubview(self)
            parentContr.bringSubview(toFront: self)
            
            parentContr.addConstraints([leadingConstraint, trailingConstraint, topConstraint, viewBottomConstraint])
        }else {
            let visibleWindow = UIWindow.visibleWindow()
            visibleWindow?.addSubview(self)
            visibleWindow?.bringSubview(toFront: self)
            
            visibleWindow?.addConstraints([leadingConstraint, trailingConstraint, topConstraint, viewBottomConstraint])
        }
        loadTableView()
    }
    
    /// this method creates dummy view on top of the window to disable the other actions.
    fileprivate func disableViewCreate() {
        
        disableView.translatesAutoresizingMaskIntoConstraints = false
        disableView.backgroundColor = UIColor.clear
        let visibleWindow = UIWindow.visibleWindow()
        visibleWindow?.addSubview(disableView)
        
        let leadingConstraint = NSLayoutConstraint(item: disableView, attribute: .leading, relatedBy: .equal, toItem: visibleWindow, attribute: .leading, multiplier: 1, constant: 0)
        let topConstraint = NSLayoutConstraint(item: disableView, attribute: .top, relatedBy: .equal, toItem: visibleWindow, attribute: .top, multiplier: 1, constant: 0)
        let trailingConstraint = NSLayoutConstraint(item: visibleWindow!, attribute: .trailing, relatedBy: .equal, toItem: disableView, attribute: .trailing, multiplier: 1, constant: 0)
        let bottomConstraint = NSLayoutConstraint(item: visibleWindow!, attribute: .bottom, relatedBy: .equal, toItem: disableView, attribute: .bottom, multiplier: 1, constant: 0)

        visibleWindow?.addConstraints([leadingConstraint,topConstraint,trailingConstraint,bottomConstraint])
        
        let gestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(self.dismissableViewTapped))
        disableView.addGestureRecognizer(gestureRecognizer)
    }
    
    @objc fileprivate func dismissableViewTapped() {
        hideDropDown()
    }
    
     /// It loads the tableview on top of the super view and setting constraints
     fileprivate func loadTableView() {
        
        addSubview(tableView)
        
        tableView.delegate = self
        tableView.dataSource = self
        
        let leadingC = NSLayoutConstraint(item: tableView, attribute: .leading, relatedBy: .equal, toItem: self, attribute: .leading, multiplier: 1, constant: 0)
        let topC = NSLayoutConstraint(item: tableView, attribute: .top, relatedBy: .equal, toItem: self, attribute: .top, multiplier: 1, constant: 0)
        let bottomC = NSLayoutConstraint(item: tableView, attribute: .bottom, relatedBy: .equal, toItem: self, attribute: .bottom, multiplier: 1, constant: 0)
        let trailingC = NSLayoutConstraint(item: tableView, attribute: .trailing, relatedBy: .equal, toItem: self, attribute: .trailing, multiplier: 1, constant: 0)
        addConstraints([leadingC,bottomC,trailingC,topC])
        tableViewReloadData()
    }
    
    /// this method can be used to show the menu tableview
    public func show() {
        
       // if isViewShowing == false {
            isViewShowing = true
            loadUIView()
            
            existParentViewLayerColor = parentView?.layer.borderColor
            parentView?.layer.borderWidth  = CGFloat(dropDownLayerBoaderWidth)
            parentView?.layer.borderColor = dropDownLayerColor.cgColor
            
            perform(#selector(self.showAnimation), with: self, afterDelay: 0.01)
//        }else {
//            hideDropDown()
//        }
    
    }
    
    @objc private func showAnimation() {
        var tableViewHeight = CGFloat(dataSourceArray.count * cellHeight)
        if tableViewHeight > 180 {
            tableViewHeight = 180
        }
        self.viewBottomConstraint.constant = tableViewHeight//(self.parentView?.frame.size.height)!+150

        UIView.animate(withDuration: 0.6, delay: 0.0, animations: {
            self.superview?.layoutIfNeeded()
            self.tableView.layer.borderColor = self.dropDownLayerColor.cgColor
            self.tableView.layer.borderWidth = CGFloat(self.dropDownLayerBoaderWidth)
        }, completion:{(success) in
            
        })
    }
    
    /// this method can be used to hide the dropdown view from the super view.
    public func hideDropDown() {
        
        self.viewBottomConstraint.constant = 0
        UIView.animate(withDuration: 0.6, animations: {
            self.superview?.layoutIfNeeded()
        }) { (success) in
            if let layerColor = self.existParentViewLayerColor {
                self.parentView?.layer.borderWidth  = CGFloat(self.dropDownLayerBoaderWidth)
                self.parentView?.layer.borderColor = layerColor
            }else {
                self.parentView?.layer.borderColor = UIColor.clear.cgColor
            }
            self.disableView.removeFromSuperview()
            self.tableView.removeFromSuperview()
            self.removeFromSuperview()
            self.isViewShowing = false
        }
        
        if  let dismissDelegate = self.dropDownDelegate?.didDismissTableViewController(dropDown: self) {
            dismissDelegate
        }
        
    }

    fileprivate func setSelectedColor(dataSourceStr: String, cellForRow cell: HONSwitchTableViewCell) {
        if let selectedString = selectedItem {
            if selectedString == dataSourceStr {
                cell.lblText.textColor = dropDownLayerColor
            }else {
                cell.lblText.textColor = cellLblTextColor
            }
        }else {
            cell.lblText.textColor = cellLblTextColor
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
            let dataString = dataSourceArray[indexPath.row]
            cell.lblText.text = dataString
            cell.selectionStyle = cellSelectionStyle
            cell.backgroundColor = cellBackgroundColor
            cell.lblText.font = lblFont
            setSelectedColor(dataSourceStr: dataString, cellForRow: cell)
            return cell
        }
        return UITableViewCell()
    }
    
    public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let dataSourceStr = dataSourceArray[indexPath.row]
        selectedItem = dataSourceStr
//        let cell: HONSwitchTableViewCell = tableView.cellForRow(at: indexPath) as! HONSwitchTableViewCell
//        setSelectedColor(dataSourceStr: dataSourceStr, cellForRow: cell)
//
        tableView.reloadData()
        if  let dropDelegate = dropDownDelegate?.didSelectTableViewTapped(index: indexPath.row, selectedMenu: selectedItem!, dropDown: self) {
            hideDropDown()
            dropDelegate
        }
        
        if let closureDelegate = didSelectedRow?(indexPath.row) {
            hideDropDown()
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
