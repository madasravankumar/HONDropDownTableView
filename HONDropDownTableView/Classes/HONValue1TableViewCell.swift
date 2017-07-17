//
//  Value1TableViewCell.swift
//  Pods
//
//  Created by Sravan Kumar on 17/07/17.
//
//

import UIKit

class HONValue1TableViewCell: UITableViewCell {

    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var imageViewLeft: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.backgroundColor = UIColor.clear
        lblTitle.adjustsFontSizeToFitWidth = true
        lblTitle.textColor = UIColor.white
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
