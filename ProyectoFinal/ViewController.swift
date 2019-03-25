//
//  ViewController.swift
//  ProyectoFinal
//
//  Created by Martín on 3/25/19.
//  Copyright © 2019 Martín Gerardo Moreno Barrera. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    
    @IBOutlet weak var tvTable: UITableView!
    @IBOutlet weak var ivSponsors: UIImageView!
    @IBOutlet weak var btLeftImage: UIButton!
    @IBOutlet weak var btRightImage: UIButton!
    
    var eventsDummy = [Eventos]()
    

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return eventsDummy.count
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    
   func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! TableViewCustomCellEvents
        cell.ivFavorite.image = UIImage(named: "favicon")
        cell.tfTitle.text = eventsDummy[indexPath.row].titulo
        cell.tfDescription.text = eventsDummy[indexPath.row].description
        let dateFormatterGet = DateFormatter()
        dateFormatterGet.dateFormat = "yyyy-MM-dd"
        cell.tfDate.text = dateFormatterGet.string(from: eventsDummy[indexPath.row].fecha)
        
        return cell
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "detail" {
            let eventDetail = segue.destination as! EventDetailViewController
            let indexPath = tvTable.indexPathForSelectedRow!
            eventDetail.ivEventImage.image = eventsDummy[indexPath.row].eventImage
            eventDetail.lbEventTitle.text = eventsDummy[indexPath.row].titulo
            eventDetail.lbUbicacion.text = eventsDummy[indexPath.row].eventUbicacion
            let dateFormatterGet = DateFormatter()
            dateFormatterGet.dateFormat = "yyyy-MM-dd"
            eventDetail.lbFecha.text = dateFormatterGet.string(from: eventsDummy[indexPath.row].fecha)
            
            
        }
    }


}

