//
//  SearchTableViewCell.swift
//  Abiding Above
//
//  Created by Caleb Hodges on 7/11/22.
//

import UIKit

class SearchTableViewCell: UITableViewCell {

    @IBOutlet weak var searchTitle: UILabel!
    @IBOutlet weak var searchMetaData: UILabel!
    @IBOutlet weak var searchView: UIView!
    @IBOutlet weak var backgroundImage: UIImageView!
    @IBOutlet weak var backgroundImageDimmer: UIView!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        searchView.styleView()
        backgroundImage.styleView()
        backgroundImageDimmer.styleView()
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
        
    }

}
