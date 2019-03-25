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
    
    var arrImg = [UIImage(named: "arca"), UIImage(named: "logotec"), UIImage(named: "gitlogo")]
    
    var eventsDummy = [Eventos]()
    var event1 = Eventos(titulo: "Evento1", fecha: Date(), eventDescription: "Este es el evento numero uno de prueba", eventUbicacion: "TEC", eventImage: UIImage(named: "fotoDummy")!)

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        eventsDummy.append(event1)
        tvTable.delegate = self
        tvTable.dataSource = self
    }
    
    func logoSlideshow() {
        var counter: Int = 0;
        UIView.animate(withDuration: 1, delay: 0, options: .repeat, animations: {
            self.ivSponsors.alpha = 0
            
        }, completion: {finished in
            counter += 1
            if counter == 3 {
                counter = 0
            }
            self.changeSponsor(index: counter)
        })
    }
    
    func changeSponsor(index: Int) {
        ivSponsors.image = arrImg[index]
    }
    
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return eventsDummy.count
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    
   func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: TableViewCustomCellEvents = tableView.dequeueReusableCell(withIdentifier: "celda", for: indexPath) as! TableViewCustomCellEvents
        cell.ivFavorite.image = UIImage(named: "favicon")
        cell.tfTitle.text = eventsDummy[indexPath.row].titulo
        cell.tfDescription.text = eventsDummy[indexPath.row].eventDescription
        let dateFormatterGet = DateFormatter()
        dateFormatterGet.dateFormat = "yyyy-MM-dd"
        cell.tfDate.text = dateFormatterGet.string(from: eventsDummy[indexPath.row].fecha)
        
        return cell
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "detail" {
            print("ENTRE A DETAIL")
            let eventDetail = segue.destination as! EventDetailViewController
            let indexPath = tvTable.indexPathForSelectedRow!
            eventDetail.evento = eventsDummy[indexPath.row]
            
            
        }
    }


}

