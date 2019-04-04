//
//  EventDetailViewController.swift
//  ProyectoFinal
//
//  Created by Martín on 3/25/19.
//  Copyright © 2019 Martín Gerardo Moreno Barrera. All rights reserved.
//

import UIKit

class EventDetailViewController: UIViewController {

    @IBOutlet weak var ivEventImage: UIImageView!
    @IBOutlet weak var lbEventTitle: UILabel!
    @IBOutlet weak var lbFecha: UILabel!
    @IBOutlet weak var lbUbicacion: UILabel!
    
    @IBOutlet weak var favButton: UIButton!
    
    var evento: Event!
    var eventManager : EventMangager!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        ivEventImage.image = evento.image
        lbEventTitle.text = evento.name
        let dateFormatterGet = DateFormatter()
        dateFormatterGet.dateFormat = "yyyy-MM-dd"
        lbFecha.text = dateFormatterGet.string(from: evento.date)
        lbUbicacion.text = evento.location
        
        favButton.imageView?.contentMode = UIView.ContentMode.scaleAspectFill
        favButton.setImage(UIImage(named: evento.favorite ? "star_gold" : "star_gray"), for: .normal)
        
        title = evento.name

        // Do any additional setup after loading the view.
    }
    
    @IBAction func setFavorite(_ sender: Any) {
        let img = evento.favorite ? "star_gray" : "star_gold"
        favButton.setImage(UIImage(named: img), for: .normal)
        evento.favorite = !evento.favorite
        eventManager.setFavorite(eventId: evento.eventId, favorite: evento.favorite)
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
