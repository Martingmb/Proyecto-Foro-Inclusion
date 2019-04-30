//
//  ViewController.swift
//  ProyectoFinal
//
//  Created by Martín on 3/25/19.
//  Copyright © 2019 Martín Gerardo Moreno Barrera. All rights reserved.
//

import UIKit
import SideMenu
import FirebaseDatabase

protocol EventMangager {
    func setFavorite(eventId : String, favorite: Bool) -> Void
    func getFavorites() -> [Event]
    func refreshEvents() -> [Event]
    func getEvent(eventId: String) -> Event?
}

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, EventMangager{
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var ivSponsors: UIImageView!
    @IBOutlet weak var btLeftImage: UIButton!
    @IBOutlet weak var btRightImage: UIButton!
    var reference: DatabaseReference!
    
    var counter: Int = 0;
    var arrImg = [UIImage(named: "arca"), UIImage(named: "logotec"), UIImage(named: "gitlogo")]
    
    var eventList : [Event] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        reference = Database.database().reference(fromURL: "https://eventos-tec.firebaseio.com/")
        
        logoSlideshow()
        refreshEvents()

        // Side menu
        SideMenuManager.defaultManager.menuFadeStatusBar = false
        definesPresentationContext = true
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
        //let event = eventList[indexPath.row]
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
    
    
    func setFavorite(eventId: String, favorite: Bool) {
        for i in 0...eventList.count-1 {
            if(eventList[i].eventId == eventId){
                eventList[i].favorite = favorite
                break;
            }
        }
        tableView.reloadData()
        // ADD TO FAVORITES
    }
    
    func getEvent(eventId: String) -> Event? {
        for i in eventList {
            if(i.eventId == eventId) {
                return i
            }
        }
        return nil
    }
    
    func getFavorites() -> [Event] {
        var favs : [Event] = []
        for i in eventList {
            if(i.favorite){
                favs.append(i)
            }
        }
        return favs
    }
    
    func refreshEvents() -> [Event] {
        let childRef = Database.database().reference().child("eventos")
        
        let oldEvents = eventList
        eventList.removeAll()
        
        var favs : [String] = []
        for i in oldEvents {
            if(i.favorite){
                favs.append(i.eventId)
            }
        }
        
        childRef.observeSingleEvent(of: .value) { (Data) in
            let value = Data.value as? NSDictionary
            let id = value?.allKeys
            
            for index in id! {
                let evento = value?[index] as? NSDictionary
                let day = evento?["fecha"] as! String
                let hour = evento?["horario"] as! String
                let strDate = day + ":" + hour
                
                let dateFormatter = DateFormatter()
                dateFormatter.dateFormat = "yyyy-MM-dd:HH:mm"
                let date = dateFormatter.date(from: strDate)
                
                let eventTest = Event(eventId: index as! String, name: evento?["evento"] as! String, date: date!, description: evento?["ambito"] as! String, location: evento?["lugar"] as! String, image: UIImage(named: "fotoDummy")!, favorite: false)
                self.eventList.append(eventTest)
            }
            // Marcar los favoritos pasados
            for i in favs{
                if let ix = self.eventList.first(where: {$0.eventId == i }){
                    print(ix)
                }
            }
            self.tableView.reloadData()
        }
        return eventList
    }
   
}

