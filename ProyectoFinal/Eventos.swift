//
//  Eventos.swift
//  ProyectoFinal
//
//  Created by Martín on 3/25/19.
//  Copyright © 2019 Martín Gerardo Moreno Barrera. All rights reserved.
//

import UIKit

class Event: NSObject {
    
    var eventId : Int
    var name : String = ""
    var date : Date
    var desc: String = ""
    var location: String = ""
    var image: UIImage!
    var favorite : Bool = false
    
    init(eventId: Int, name: String, date: Date, description: String, location: String, image: UIImage, favorite : Bool) {
        self.eventId = eventId
        self.name = name
        self.date = date
        self.desc = description
        self.location = location
        self.image = image
        self.favorite = favorite
    }
    

}
