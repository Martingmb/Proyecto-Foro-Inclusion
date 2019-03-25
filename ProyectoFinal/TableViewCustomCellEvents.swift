//
//  TableViewCustomCellEvents.swift
//  ProyectoFinal
//
//  Created by Martín on 3/25/19.
//  Copyright © 2019 Martín Gerardo Moreno Barrera. All rights reserved.
//

import UIKit

class TableViewCustomCellEvents: UITableViewCell {
    
    
    @IBOutlet weak var ivFavorite: UIImageView!
    @IBOutlet weak var tfTitle: UILabel!
    @IBOutlet weak var tfDate: UILabel!
    @IBOutlet weak var tfDescription: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
