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
    
    var counter: Int = 0;
    var arrImg = [UIImage(named: "arca"), UIImage(named: "logotec"), UIImage(named: "gitlogo")]
    
    var eventsDummy = [Eventos]()
    var event1 = Eventos(titulo: "Evento1", fecha: Date(), eventDescription: "Este es el evento numero uno de prueba", eventUbicacion: "TEC", eventImage: UIImage(named: "fotoDummy")!)
    var event2 = Eventos(titulo: "Evento2", fecha: Date(), eventDescription: "Este es el evento numero dos de prueba", eventUbicacion: "Salon 402", eventImage: UIImage(named: "fotoDummy")!)
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        eventsDummy.append(event1)
        eventsDummy.append(event2)
        logoSlideshow()
        tvTable.delegate = self
        tvTable.dataSource = self
    }
    
    func logoSlideshow() {
        
        UIView.animate(withDuration: 2, delay: 1, options: .curveEaseIn, animations: {
            self.ivSponsors.alpha = 0
        }, completion: {finished in
            self.counter += 1
            if self.counter == 3 {
                self.counter = 0
            }
            self.logoSlideShowFadeIN()
            self.changeSponsor(index: self.counter)
            
        })
    }
    
    func logoSlideShowFadeIN() {
        UIView.animate(withDuration: 3, delay: 1, options: .curveEaseIn, animations: {
            self.ivSponsors.alpha = 1
        }, completion: nil)
    }
    
    func changeSponsor(index: Int) {
        ivSponsors.image = arrImg[index]
        logoSlideshow()
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

