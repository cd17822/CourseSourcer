//
//  NewCourseTableViewCell.swift
//  CourseSourcer
//
//  Created by Charlie on 7/19/16.
//  Copyright © 2016 cd17822. All rights reserved.
//

import UIKit

class NewCourseTableViewCell: UITableViewCell {
    @IBOutlet weak var title_label: UILabel!
    @IBOutlet weak var subtitle_label: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
}
