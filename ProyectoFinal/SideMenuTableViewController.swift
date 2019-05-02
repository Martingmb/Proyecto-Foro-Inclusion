//
//  SideMenuTableViewController.swift
//  ProyectoFinal
//
//  Created by Andrés Sánchez on 5/1/19.
//  Copyright © 2019 Martín Gerardo Moreno Barrera. All rights reserved.
//

import UIKit
import SideMenu

class SideMenuTableViewController: UITableViewController {

    var eventManager : EventMangager!
    
    @IBOutlet weak var lbFavoritos: UILabel!
    
    @IBOutlet weak var cellFavs: UITableViewCell!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        cellFavs.accessibilityLabel = "Mis Favoritos"
        
        cellFavs.accessibilityHint = "Toca dos veces para ir a tu lista de favoritos"
        
        
        
    }

    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if(segue.identifier == "favorites"){
            let vc = segue.destination as! FavoritesTableViewController
            vc.eventManager = eventManager
        }
    }

}
