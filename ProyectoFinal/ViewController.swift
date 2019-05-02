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
    func getEvents() -> [Event]
    func getFilteredEvents(text : String, ambito: String?, discapacidad: String?, fecha: Date?) -> [Event]
}

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, EventMangager{
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var ivSponsors: UIImageView!
    
    @IBOutlet weak var btMenu: UIBarButtonItem!
    @IBOutlet weak var btSearch: UIBarButtonItem!
    
    
    
    
    
    
    var reference: DatabaseReference!
    var refreshControl : UIRefreshControl!
    
    var counter: Int = 0;
    var arrImg = [UIImage(named: "arca"), UIImage(named: "logotec"), UIImage(named: "gitlogo")]
    
    var eventList : [Event] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        reference = Database.database().reference(fromURL: "https://eventos-tec.firebaseio.com/")
        
        refreshControl = UIRefreshControl()
        tableView.refreshControl = refreshControl
        refreshControl.addTarget(self, action: #selector(refreshControlEvents(_:)), for: .valueChanged)
        
        logoSlideshow()
        let _ = refreshEvents()

        // Side menu
        SideMenuManager.defaultManager.menuFadeStatusBar = false
        
        definesPresentationContext = true
        
        
        //------------Accesibilidad
        btMenu.accessibilityLabel = "Menú"
        btMenu.accessibilityHint = "Toca dos veces para desplegar o cerrar el menú"
        
        btSearch.accessibilityLabel = "Búsqueda"
        btSearch.accessibilityHint = "Toca dos veces para realizar una búsqueda de eventos"
        
        
    }
    
    func logoSlideshow() {
        UIView.animate(withDuration: 2, delay: 0, options: .curveEaseIn, animations: {
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
        return 1
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 90;
    }
    
   func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: TableViewCustomCellEvents = tableView.dequeueReusableCell(withIdentifier: "celda", for: indexPath) as! TableViewCustomCellEvents
        //let event = eventList[indexPath.row]
        let event = eventList[indexPath.row]
        cell.ivFavorite.image = UIImage(named: event.favorite ? "star_gold" : "star_gray")
        cell.tfTitle.text = event.name
        cell.tfAmbito.text = event.ambito
    
        let df = DateFormatter()
        df.locale = Locale(identifier: "es-MX")
        df.dateFormat = "EEEE, MMM d, yyyy"
        cell.tfDate.text = df.string(from: event.date)
    
        return cell
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "detail" {
            let eventDetail = segue.destination as! EventDetailViewController
            let indexPath = tableView.indexPathForSelectedRow!
            eventDetail.evento = eventList[indexPath.row]
            eventDetail.eventManager = self
            tableView.deselectRow(at: indexPath, animated: true)
        } else if segue.identifier == "filter" {
            let vc = segue.destination as! SearchViewController
            vc.eventManager = self
        } else if segue.identifier == "sideMenu" {
            let nc = segue.destination as! UISideMenuNavigationController
            let vc = nc.viewControllers.first as! SideMenuTableViewController
            vc.eventManager = self
        }
    }
    
    func getFavoritesPath() -> String{
        return FileManager().urls(for: .documentDirectory, in: .userDomainMask).first!.appendingPathComponent("favorites.plist").path
    }
    
    
    func setFavorite(eventId: String, favorite: Bool) {
        for i in 0...eventList.count-1 {
            if(eventList[i].eventId == eventId){
                eventList[i].favorite = favorite
                break;
            }
        }
        tableView.reloadData()
        
        // Guardar favoritos en un plist
        
        let array : NSMutableArray = []
        for i in eventList{
            if(i.favorite){
                array.add(i.eventId)
            }
        }
        
        array.write(toFile: getFavoritesPath(), atomically: true)
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
    
    func getEvents() -> [Event] {
        return eventList
    }
    
    func refreshEvents() -> [Event] {
        let childRef = Database.database().reference().child("eventos")
        
        eventList.removeAll()
        refreshControl.beginRefreshing()
        
        var favs : NSArray = []
        if(FileManager.default.fileExists(atPath: getFavoritesPath())){
            favs = NSArray(contentsOfFile: getFavoritesPath())!
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
                
                let eventTest = Event(eventId: index as! String, name: evento?["evento"] as! String, date: date!, ambito: evento?["ambito"] as! String, location: evento?["lugar"] as! String, discapacidad: evento?["discapacidad"] as! String, favorite: false)
                self.eventList.append(eventTest)
            }
            // Marcar los favoritos pasados
            for i in favs{
                if let ix = self.eventList.first(where: {$0.eventId == (i as! String) }){
                    ix.favorite = true
                }
            }
            self.refreshControl.endRefreshing()
            self.tableView.reloadData()
        }
        return eventList
    }
    
    func getFilteredEvents(text : String, ambito: String?, discapacidad: String?, fecha: Date?) -> [Event] {
        return eventList.filter({ (e) -> Bool in
            var a = true, d = true, f = true, t = true
            if (ambito != nil) {
                a = e.ambito == ambito
            }
            if(discapacidad != nil){
                d = e.discapacidad == discapacidad
            }
            if(fecha != nil){
                // Esto es una tonteria pero funciona.
                let df = DateFormatter()
                df.dateFormat = "MMMM d, YYYY"
                f = df.string(from: e.date) == df.string(from: fecha!)
            }
            if(text.count>0){
                t = e.name.uppercased().contains(text.uppercased())
            }
            return a && d && f && t
        })
    }
    
    
    @objc func refreshControlEvents(_ sender: Any){
        refreshEvents()
    }
    
}

