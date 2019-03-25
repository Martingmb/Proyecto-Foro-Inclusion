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
    
    var evento: Eventos!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        ivEventImage.image = evento.eventImage
        lbEventTitle.text = evento.titulo
        let dateFormatterGet = DateFormatter()
        dateFormatterGet.dateFormat = "yyyy-MM-dd"
        lbFecha.text = dateFormatterGet.string(from: evento.fecha)
        lbUbicacion.text = evento.eventUbicacion

        // Do any additional setup after loading the view.
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
