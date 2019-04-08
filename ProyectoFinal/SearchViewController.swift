//
//  SearchViewController.swift
//  ProyectoFinal
//
//  Created by Andrés Sánchez on 4/8/19.
//  Copyright © 2019 Martín Gerardo Moreno Barrera. All rights reserved.
//

import UIKit

class SearchViewController: UIViewController {

    var locations : [String] = []
    
    @IBOutlet weak var dateButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
    }
    
    @IBAction func dateFilter(_ sender: Any) {
        showActions(button: sender as! UIButton, actions: ["Fecha1", "Fecha2", "Fecha3"])
    }
    
    func showActions(button : UIButton, actions : [String]){
        let optionMenu = UIAlertController(title: nil, message: "Filtrar", preferredStyle: .actionSheet)
        for i in actions {
            let act = UIAlertAction(title: i, style: .default){ (action) in self.selectedFilter(button: button, selection: action.title!)
            }
            optionMenu.addAction(act)
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel)
        optionMenu.addAction(cancelAction)
        
        self.present(optionMenu, animated: true, completion: nil)
    }
    
    func selectedFilter(button : UIButton, selection : String){
        button.titleLabel?.text = "\(selection) >"
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
