//
//  HONButtonView.swift
//  Pods
//
//  Created by Sravan Kumar on 02/08/17.
//
//

import UIKit

@objc public protocol HONButtonViewDelegate {
    @objc optional func buttonViewTapped(forView: HONButtonView)
    @objc optional func dropDownView(_ dropDown: HONDropDownTableViewController, didSelectedItem item: String, atIndex index: Int)
}


public class HONButtonView: UIView {
    
    let bundle = Bundle(for: HONButtonView.self)

    ///types of the drop down menu
    enum DropDownType: Int {
        case defaultType = 1
        case inactiveType
    }
    
    struct DropDownColors {
        let defaultLayerColor = UIColor(red: 208/255, green: 208/255, blue: 208/255, alpha: 1)
        let inactiveLayerColor = UIColor(red: 80/255, green: 80/255, blue: 80/255, alpha: 1)
        let heighlightedLayerColor = UIColor(red: 48/255, green: 181/255, blue: 244/255, alpha: 1)
    }
    
    public var dropDownTable: HONDropDownTableViewController!
    
    /// when user sets the menu type it will changes the color of the boaders, text and images.
    
    public var menuType = DropDownType.defaultType.rawValue {
        willSet {
            if newValue == 2 {
                self.isUserInteractionEnabled = false
                self.layer.borderColor = DropDownColors().inactiveLayerColor.cgColor
                self.titleButton.setTitleColor(DropDownColors().inactiveLayerColor, for: .normal)
                self.arrowImage.image = UIImage.init(assetIdentifer: "Chevron_Down_Inactive")
            }else {
                self.layer.borderColor = DropDownColors().defaultLayerColor.cgColor
                self.titleButton.setTitleColor(DropDownColors().defaultLayerColor, for: .normal)
            }
        }
    }

    ///set the list of data to show on the tableview as menu.
    public var dataSourceArray = [String]() {
        willSet{
            dropDownTable.dataSourceArray = newValue
        }
    }
    
    /// Selected item can store when user selected on drop down view
    public var selectedItem: String? = "" {
        willSet {
            dropDownTable.selectedItem = newValue
            self.titleButton.setTitle(newValue, for: .normal)
        }
    }
    
    /// default text should be displayed on button
    @IBInspectable public var defaultText: String? = "Recently Computed" {
        willSet {
            self.titleButton.setTitle(newValue, for: .normal)
        }
    }
    
    ///Default image for arrow image.
    public var defaultArrowImage: UIImage? = UIImage.init(assetIdentifer: "Chevron_Down") {
        willSet {
            self.arrowImage.image = newValue
        }
    }
    
    public var selectArrowImage: UIImage? = UIImage.init(assetIdentifer: "Chevron_Up")
    
    public var direction = DropDownDirection.bottom.rawValue {
        willSet{dropDownTable.direction = newValue}
    }

    //MARK:- private properties.
    @IBOutlet fileprivate weak var titleButton: UIButton!
    @IBOutlet fileprivate weak var arrowImage: UIImageView!
    
    @IBInspectable public var titleButtonTextColor: UIColor = UIColor(red: 48/255, green: 181/255, blue: 244/255, alpha: 1) {
        willSet{self.titleButton.setTitleColor(newValue, for: .normal)}
    }

    @IBOutlet public var delegate: AnyObject?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }
    
    
    /// intital method to setup the custom components default values.
    private func setup() {
        let viewFromNib = viewFromNibForClass()
        viewFromNib.frame = bounds
        self.addSubview(viewFromNib)
        
        self.layer.borderColor = DropDownColors().defaultLayerColor.cgColor
        self.layer.borderWidth = 1.5
        self.layer.masksToBounds = true
        
        titleButton.backgroundColor = UIColor.black
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(self.openDropDownTableTap))
        tapGesture.numberOfTapsRequired = 1
        self.addGestureRecognizer(tapGesture)
        
        //Create instance of the dropdown table menu
        dropDownTable = HONDropDownTableViewController(withFrame: CGRect.zero, parentView: self, cellStyle: HONDropDownTableViewController.CustomCellType(rawValue: 1)!)
        dropDownTable?.dropDownDelegate = self
        dropDownTable?.dataSourceArray = dataSourceArray
        dropDownTable?.selectedItem = selectedItem
        dropDownTable?.direction = direction

    }
    
    
    /// this method can be used to show the dropdown table when user taps on the view.
    @objc private func openDropDownTableTap() {
        dropDownTable?.show()
        arrowImage.image = selectArrowImage
    }

    
    /// this method can be used to load the xib into the class.
    ///
    /// - Returns: custom uiview of the HONButtonView class.
    private func viewFromNibForClass() -> UIView {
        
        let bundle = Bundle(for: type(of: self))
        let nib = UINib(nibName: "HONButtonView", bundle: bundle)
        let view = nib.instantiate(withOwner: self, options: nil).last as? UIView
        return view!
    }
}

//MARK:- HONDropDownTableViewControllerProtocol Methods

extension HONButtonView: HONDropDownTableViewControllerProtocol {
   
    public func didSelectTableViewTapped(index: Int, selectedMenu: String, dropDown: HONDropDownTableViewController) {
      
        titleButton.setTitle(selectedMenu, for: .normal)
        titleButton.setTitleColor(DropDownColors().heighlightedLayerColor, for: .normal)
        arrowImage.image = defaultArrowImage

        if let dropDownDelegate =  self.delegate?.dropDownView!(dropDown, didSelectedItem: selectedMenu, atIndex: index) {
            dropDownDelegate
        }
    }
    
    public func didDismissTableViewController(dropDown: HONDropDownTableViewController) {
        arrowImage.image = defaultArrowImage
    }
}

extension UIImage {
     convenience init(assetIdentifer: String) {
        self.init(named : assetIdentifer, in : Bundle(for: HONButtonView.self), compatibleWith : nil)!
    }
}
