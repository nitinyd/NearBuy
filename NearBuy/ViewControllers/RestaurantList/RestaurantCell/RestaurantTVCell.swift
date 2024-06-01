//
//  RestaurantTVCell.swift
//  NearBuy
//
//  Created by Nitin Yadav on 1/6/2024.
//

import UIKit

class RestaurantTVCell: UITableViewCell {

    var venueData: Venue? {
        didSet {
            refreshView()
        }
    }
    
    @IBOutlet private var nameLabel: UILabel!
    @IBOutlet private var detailLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
}

extension RestaurantTVCell {
    private func refreshView() {
        guard let data = venueData
        else { return }
        nameLabel.text = data.name
        detailLabel.text = data.displayLocation
    }
}
