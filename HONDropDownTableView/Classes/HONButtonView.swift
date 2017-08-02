//
//  HONButtonView.swift
//  Pods
//
//  Created by Sravan Kumar on 02/08/17.
//
//

import UIKit

/*public protocol HONButtonViewDelegate {
    func buttonViewTapped(forView: HONButtonView)
}*/

public class HONButtonView: UIView {
    
    public var dropDownTable: HONDropDownTableViewController!
   
    ///Default image for arrow image.
    public var defaultArrowImage: UIImage? = UIImage(named: "Chevron_Down") {
        willSet {
            self.arrowImage.image = newValue
        }
    }
    
    public var selectArrowImage: UIImage? = UIImage(named: "Chevron_Up")
    public var direction = DropDownDirection.bottom.rawValue {
        willSet{dropDownTable.direction = newValue}
    }

    //MARK:- private properties.
    @IBOutlet fileprivate weak var titleButton: UIButton!
    @IBOutlet fileprivate weak var arrowImage: UIImageView!
    
    @IBInspectable public var titleButtonTextColor: UIColor = UIColor(red: 48/255, green: 181/255, blue: 244/255, alpha: 1) {
        willSet{self.titleButton.setTitleColor(newValue, for: .normal)}
    }

//    public var delegate: HONButtonViewDelegate?
    
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
        
        self.layer.borderColor = UIColor(red: 48/255, green: 181/255, blue: 244/255, alpha: 1).cgColor
        self.layer.borderWidth = 1.5
        self.layer.masksToBounds = true
        
        titleButton.backgroundColor = UIColor.black
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(self.openDropDownTableTap))
        tapGesture.numberOfTapsRequired = 1
        self.addGestureRecognizer(tapGesture)
        
        //Create instance of the dropdown table menu
        dropDownTable = HONDropDownTableViewController(withFrame: CGRect.zero, parentView: self, cellStyle: HONDropDownTableViewController.CustomCellType(rawValue: 1)!)
        dropDownTable?.dropDownDelegate = self
        dropDownTable?.dataSourceArray = ["Recently Computed","ETD","Tail","Filing Status","Departure","Destination","Hidden Flight Plans"]
        dropDownTable?.selectedItem = "Recently Computed"
        dropDownTable?.direction = direction

    }
    
    
    /// this method can be used to show the dropdown table when user taps on the view.
    @objc private func openDropDownTableTap() {
        dropDownTable?.show()
        
        if let selectedImage = selectArrowImage {
            arrowImage.image = selectedImage
        }else {
            let bundle = Bundle(for: HONButtonView.self)
            arrowImage.image = UIImage(named: "Chevron_Up", in: bundle, compatibleWith: nil)
        }
        
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
        if let defaultImage = defaultArrowImage {
            arrowImage.image = defaultImage
        }else {
            let bundle = Bundle(for: HONButtonView.self)
            arrowImage.image = UIImage(named: "Chevron_Down", in: bundle, compatibleWith: nil)
        }
    }
    
    public func didDismissTableViewController(dropDown: HONDropDownTableViewController) {
       
    }
}
