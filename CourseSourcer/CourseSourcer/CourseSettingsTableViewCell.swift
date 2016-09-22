//
//  CourseSettingsTableViewCell.swift
//  CourseSourcer
//
//  Created by Charlie on 7/21/16.
//  Copyright © 2016 cd17822. All rights reserved.
//

import UIKit

class CourseSettingsTableViewCell: UITableViewCell {

    @IBOutlet weak var label: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        selectionStyle = UITableViewCellSelectionStyle.none
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

}
