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
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if(segue.identifier == "favorites"){
            let vc = segue.destination as! FavoritesTableViewController
            vc.eventManager = eventManager
        }
    }

}
