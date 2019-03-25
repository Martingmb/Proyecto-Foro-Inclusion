//
//  Eventos.swift
//  ProyectoFinal
//
//  Created by Martín on 3/25/19.
//  Copyright © 2019 Martín Gerardo Moreno Barrera. All rights reserved.
//

import UIKit

class Eventos: NSObject {
    
    var titulo : String = ""
    var fecha : Date
    var eventDescription: String = ""
    var eventUbicacion: String = ""
    var eventImage: UIImage!
    
    init(titulo: String, fecha: Date, eventDescription: String, eventUbicacion: String, eventImage: UIImage) {
        self.titulo = titulo
        self.fecha = fecha
        self.eventDescription = eventDescription
        self.eventUbicacion = eventUbicacion
        self.eventImage = eventImage
    }
    

}
