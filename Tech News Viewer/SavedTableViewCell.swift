//
//  SavedTableViewCell.swift
//  Tech News Viewer
//
//  Created by Никита Бычков on 03/04/2019.
//  Copyright © 2019 Никита Бычков. All rights reserved.
//

import UIKit

class SavedTableViewCell: UITableViewCell {

    @IBOutlet weak var headlineLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
