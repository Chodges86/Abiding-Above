//
//  TopicCell.swift
//  Abiding Above
//
//  Created by Caleb Hodges on 11/3/21.
//

import UIKit

class TopicCell: UITableViewCell {

    @IBOutlet weak var topicLabel: UILabel!
    @IBOutlet weak var cellView: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        cellView.layer.cornerRadius = cellView.frame.size.height / 5
        cellView.layer.shadowOffset = CGSize(width: 10, height: 10)
        cellView.layer.shadowRadius = 5
        cellView.layer.shadowOpacity = 0.3

    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}

