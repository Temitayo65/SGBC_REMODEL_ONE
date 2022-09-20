//
//  AboutTableViewCell.swift
//  SGBC_REMODEL
//
//  Created by ADMIN on 20/09/2022.
//

import UIKit

class AboutTableViewCell: UITableViewCell {
 
    @IBOutlet weak var sectionTextLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    
    func configureCell(with info: [String], atIndex indexPath: Int){
        sectionTextLabel.text = info[indexPath]
    }
    
}
