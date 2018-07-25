//
//  ShoppingListCell.swift
//  menufly
//
//  Created by winifred irarrazaval Oehninger on 7/24/18.
//  Copyright © 2018 winifred irarrazaval Oehninger. All rights reserved.
//

import UIKit

class ShoppingListCell: UITableViewCell {
    
    @IBOutlet weak var ingredientName:UILabel!
    @IBOutlet weak var quantity:UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
