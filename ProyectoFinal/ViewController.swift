//
//  ViewController.swift
//  ProyectoFinal
//
//  Created by Martín on 3/25/19.
//  Copyright © 2019 Martín Gerardo Moreno Barrera. All rights reserved.
//

import UIKit
import SideMenu

protocol EventMangager {
    func setFavorite(eventId : Int, favorite: Bool) -> Void
}

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, EventMangager {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var ivSponsors: UIImageView!
    @IBOutlet weak var btLeftImage: UIButton!
    @IBOutlet weak var btRightImage: UIButton!
    
    var counter: Int = 0;
    var arrImg = [UIImage(named: "arca"), UIImage(named: "logotec"), UIImage(named: "gitlogo")]
    
    var eventList : [Event] = []
    let lorem = "pruba lmao"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        eventList += [
            Event(eventId: 0, name: "Prueba1", date: Date(), description: lorem, location: "Tec de Monterrey", image: UIImage(named: "fotoDummy")!, favorite: false),
            Event(eventId: 1, name: "Prueba2", date: Date(), description: lorem, location: "Tec de Monterrey", image: UIImage(named: "fotoDummy")!, favorite: false),
            Event(eventId: 2, name: "Prueba3", date: Date(), description: lorem, location: "Tec de Monterrey", image: UIImage(named: "fotoDummy")!, favorite: false),
        ]
        logoSlideshow()
        SideMenuManager.defaultManager.menuFadeStatusBar = false
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
        return eventList.count
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80;
    }
    
   func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: TableViewCustomCellEvents = tableView.dequeueReusableCell(withIdentifier: "celda", for: indexPath) as! TableViewCustomCellEvents
    
        let event = eventList[indexPath.row]
    
        cell.ivFavorite.image = UIImage(named: event.favorite ? "star_gold" : "star_gray")
        cell.tfTitle.text = event.name
    
        let dateFormatterGet = DateFormatter()
        dateFormatterGet.dateFormat = "yyyy-MM-dd"
        cell.tfDate.text = dateFormatterGet.string(from: event.date)
        
        return cell
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "detail" {
            let eventDetail = segue.destination as! EventDetailViewController
            let indexPath = tableView.indexPathForSelectedRow!
            eventDetail.evento = eventList[indexPath.row]
            eventDetail.eventManager = self
        }
    }
    
    
    func setFavorite(eventId: Int, favorite: Bool) {
        for i in 0...eventList.count-1 {
            if(eventList[i].eventId==eventId){
                eventList[i].favorite = favorite
                break;
            }
        }
        tableView.reloadData()
        // ADD TO FAVORITES
    }


}

