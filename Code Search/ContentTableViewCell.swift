//
//  ContentTableViewCell.swift
//  Code Search
//
//  Created by Kis User on 5/4/21.
//

import UIKit

class ContentTableViewCell: UITableViewCell {

    @IBOutlet weak var cellView: UIView!
    @IBOutlet weak var contentImage: UIImageView!
    @IBOutlet weak var contentLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
}
