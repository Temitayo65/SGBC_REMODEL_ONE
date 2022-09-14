//
//  RecentSermonTableViewCell.swift
//  SGBC_REMODEL
//
//  Created by ADMIN on 13/09/2022.
//

import UIKit

class RecentSermonTableViewCell: UITableViewCell {

    @IBOutlet var RecentSermonImageView: UIImageView!
    @IBOutlet var RecentSermonTitleLabel: UILabel!
    @IBOutlet var RecentSermonPreacherName: UILabel!
    @IBOutlet var RecentSermonDate: UILabel!
    
    override func awakeFromNib() {
       super.awakeFromNib()
        RecentSermonImageView.layer.cornerRadius = 10
        RecentSermonImageView.layer.masksToBounds = true
        RecentSermonImageView.clipsToBounds = true
        RecentSermonPreacherName.textColor = .blue
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
