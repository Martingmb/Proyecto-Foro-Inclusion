//
//  FavoritesTableViewController.swift
//  ProyectoFinal
//
//  Created by Andrés Sánchez on 5/1/19.
//  Copyright © 2019 Martín Gerardo Moreno Barrera. All rights reserved.
//

import UIKit

class FavoritesTableViewController: UITableViewController, FavoriteListener {

    var favorites : [Event] = []
    var eventManager : EventMangager!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        favorites = eventManager.getFavorites()
        self.title = "Favoritos"
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return favorites.count
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 90
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "favorite", for: indexPath) as! FavoriteTableViewCell
        
        let event = favorites[indexPath.row]
        
        cell.titleLabel.text = event.name
        cell.ambitoLabel.text = event.ambito
        
        let df = DateFormatter()
        df.locale = Locale(identifier: "es-MX")
        df.dateFormat = "EEEE, MMM d - hh:mm a"
        cell.dateLabel.text = df.string(from: event.date)
        return cell
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let vc = segue.destination as! EventDetailViewController
        vc.eventManager = eventManager
        let indexPath = tableView.indexPathForSelectedRow!
        vc.evento = favorites[indexPath.row]
        vc.favoriteListener = self
    }
    
    func onFavoriteChange(eventId: String, favorite: Bool) {
        favorites = eventManager.getFavorites()
        tableView.reloadData()
    }

}
