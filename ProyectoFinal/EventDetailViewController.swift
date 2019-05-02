//
//  EventDetailViewController.swift
//  ProyectoFinal
//
//  Created by Martín on 3/25/19.
//  Copyright © 2019 Martín Gerardo Moreno Barrera. All rights reserved.
//

import UIKit
import EventKit
import EventKitUI

protocol FavoriteListener {
    func onFavoriteChange(eventId : String, favorite : Bool) -> Void
}

class EventDetailViewController: UIViewController, EKEventEditViewDelegate {

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var locationLabel: UILabel!
    @IBOutlet weak var ambitoLabel: UILabel!
    @IBOutlet weak var discapacidadLabel: UILabel!
    
    @IBOutlet weak var btAsistir: UIButton!
    @IBOutlet weak var favButton: UIButton!
    
    var evento: Event!
    var eventManager : EventMangager!
    var favoriteListener : FavoriteListener?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        titleLabel.text = evento.name
        locationLabel.text = evento.location
        ambitoLabel.text = evento.ambito
        discapacidadLabel.text = evento.discapacidad
        
        let df = DateFormatter()
        df.locale = Locale(identifier: "es-MX")
        df.dateFormat = "EEEE, MMM d - hh:mm a"
        
        dateLabel.text = df.string(from: evento.date)
        
        favButton.imageView?.contentMode = UIView.ContentMode.scaleAspectFill
        favButton.setImage(UIImage(named: evento.favorite ? "star_gold" : "star_gray"), for: .normal)
        
        title = evento.name
        
        favButton.accessibilityLabel = evento.favorite ? "Si es favorito" : "No es favorito"
        favButton.accessibilityHint = evento.favorite ? "Toca dos veces para eliminar de favoritos" : "Toca dos veces para añadir a favoritos"
        btAsistir.accessibilityLabel = "Asistir al evento"
        btAsistir.accessibilityHint = "Toca dos veces para añadir el evento a tu calendario"

        // Do any additional setup after loading the view.
    }
    
    @IBAction func setFavorite(_ sender: Any) {
        let img = evento.favorite ? "star_gray" : "star_gold"
        favButton.setImage(UIImage(named: img), for: .normal)
        evento.favorite = !evento.favorite
        eventManager.setFavorite(eventId: evento.eventId, favorite: evento.favorite)
        favoriteListener?.onFavoriteChange(eventId: evento.eventId, favorite: evento.favorite)
        favButton.accessibilityLabel = evento.favorite ? "Si es favorito" : "No es favorito"
        favButton.accessibilityHint = evento.favorite ? "Toca dos veces para eliminar de favoritos" : "Toca dos veces para añadir a favoritos"
    }
    
    @IBAction func onAssistClick(_ sender: Any) {
        let store = EKEventStore()
        
        store.requestAccess(to: EKEntityType.event) { (granted : Bool, error : Error?) in
            let event = EKEvent(eventStore: store)
            event.title = self.evento.name
            event.startDate = self.evento.date
            event.endDate = self.evento.date.addingTimeInterval(30*60)
            event.location = self.evento.location
            event.notes = "Ambito: \(self.evento.ambito)\nDiscapacidad: \(self.evento.discapacidad)\n(Fecha final no fija)"
            
            let controller = EKEventEditViewController()
            controller.event = event
            controller.eventStore = store
            controller.editViewDelegate = self
            self.present(controller, animated: true)
        }
    }
    
    func eventEditViewController(_ controller: EKEventEditViewController, didCompleteWith action: EKEventEditViewAction) {
        controller.dismiss(animated: true, completion: nil)
    }
    
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
