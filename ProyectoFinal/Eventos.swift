//
//  Eventos.swift
//  ProyectoFinal
//
//  Created by Martín on 3/25/19.
//  Copyright © 2019 Martín Gerardo Moreno Barrera. All rights reserved.
//

import UIKit

class Event: NSObject {
    
    var eventId : String
    var name : String = ""
    var date : Date
    var ambito : String = ""
    var location : String = ""
    var discapacidad : String = ""
    var image : UIImage?
    var favorite : Bool = false
    
    init(eventId: String, name: String, date: Date, ambito: String, location: String, discapacidad : String, favorite : Bool) {
        self.eventId = eventId
        self.name = name
        self.date = date
        self.ambito = ambito
        self.location = location
        self.discapacidad = discapacidad
        self.image = nil
        self.favorite = favorite
    }
    

}
