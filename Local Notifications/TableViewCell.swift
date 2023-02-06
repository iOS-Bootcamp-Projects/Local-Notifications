//
//  TableViewCell.swift
//  Local Notifications
//
//  Created by Aamer Essa on 28/11/2022.
//

import UIKit

class TableViewCell: UITableViewCell {

    @IBOutlet weak var timerLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
