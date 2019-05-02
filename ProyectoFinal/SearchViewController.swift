//
//  SearchViewController.swift
//  ProyectoFinal
//
//  Created by Andrés Sánchez on 4/8/19.
//  Copyright © 2019 Martín Gerardo Moreno Barrera. All rights reserved.
//

import UIKit

class SearchViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UIPickerViewDataSource, UIPickerViewDelegate, UISearchBarDelegate, FavoriteListener {

    var eventManager : EventMangager!
    
    @IBOutlet weak var filterTableView: UITableView!
    @IBOutlet weak var eventTableView: UITableView!
    
    @IBOutlet weak var picker: UIPickerView!
    @IBOutlet weak var datePicker: UIDatePicker!
    @IBOutlet weak var searchBar: UISearchBar!
    
    var pickerDefaultY : CGFloat = CGFloat(0)
    var filteredEvents : [Event] = []
    var filters = ["Ambito", "Discapacidad", "Fecha"]
    var setFilters : [String?] = [nil, nil]
    var setFilterDate : Date? = nil
    var filterData = [
        ["Cualquiera"],
        ["Cualquiera"]
    ]
    var changingFilter = 0
    var pickerData : [String] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        picker.isHidden = true
        datePicker.isHidden = true
        datePicker.backgroundColor = UIColor(red: 239, green: 239, blue: 239, alpha: 1)
        picker.backgroundColor = UIColor(red: 239, green: 239, blue: 239, alpha: 1)
        
        view.bringSubviewToFront(picker)
        view.bringSubviewToFront(datePicker)
        view.sendSubviewToBack(eventTableView)
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(hidePickers))
        tapGesture.cancelsTouchesInView = false
        tapGesture.numberOfTapsRequired = 1
        view.addGestureRecognizer(tapGesture)
        
        filteredEvents = eventManager.getEvents()
        filterData[0] += filteredEvents.map({ (e) -> String in
            return e.ambito
        })
        filterData[1] += filteredEvents.map({ (e) -> String in
            return e.discapacidad
        })
        
        //------------Accesibilidad
        searchBar.accessibilityLabel = "Campo de búsqueda para buscar un evento"
        searchBar.accessibilityHint = "Toca dos veces para editar"
        
        
    }

    override func viewWillAppear(_ animated: Bool) {
        pickerDefaultY = picker.frame.origin.y
    }
    
    // MARK: TableView
   
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if(tableView == filterTableView){
            if(indexPath.row==2){
                showDatePicker()
            }else{
                showPicker(data: filterData[indexPath.row])
            }
            changingFilter = indexPath.row
        }else{
            eventTableView.deselectRow(at: indexPath, animated: true)
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tableView == filterTableView ? filters.count : filteredEvents.count
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if(tableView == filterTableView){
            let cell = tableView.dequeueReusableCell(withIdentifier: "filter", for: indexPath)
            
            cell.textLabel?.text = filters[indexPath.row];
            cell.detailTextLabel?.text = "Cualquiera"
            
            return cell
        }else{
            let cell = tableView.dequeueReusableCell(withIdentifier: "celda", for: indexPath) as! TableViewCustomCellEvents
            let event = filteredEvents[indexPath.row]
            cell.ivFavorite.image = UIImage(named: event.favorite ? "star_gold" : "star_gray")
            cell.tfTitle.text = event.name
            cell.tfAmbito.text = event.ambito
            
            let dateFormatterGet = DateFormatter()
            dateFormatterGet.locale = Locale(identifier: "es-MX")
            dateFormatterGet.dateFormat = "EEEE, MMM d - hh:mm a"
            cell.tfDate.text = dateFormatterGet.string(from: event.date)
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return tableView == eventTableView ? 90 : 44
    }
    
    func refreshEvents(){
        filteredEvents = eventManager.getFilteredEvents(text: searchBar.text!, ambito: setFilters[0], discapacidad: setFilters[1], fecha: setFilterDate)
        eventTableView.reloadData()
    }
    
    
    // MARK: Picker
    
    @objc func hidePickers(){
        picker.isHidden = true
        datePicker.isHidden = true
        filterTableView.deselectRow(at: IndexPath(row: changingFilter, section: 0), animated: true)
    }
    
    func showDatePicker(){
        datePicker.isHidden = false
    }
    
    func showPicker(data : [String]){
        pickerData = data
        picker.reloadAllComponents()
        picker.isHidden = false
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return pickerData.count
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        filterTableView.cellForRow(at: IndexPath(row: changingFilter, section: 0))?.detailTextLabel?.text = pickerData[row]
        setFilters[changingFilter] = row == 0 ? nil : pickerData[row]
        refreshEvents()
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return pickerData[row]
    }
    
    @IBAction func datePickerChanged(_ picker: UIDatePicker) {
        let df = DateFormatter()
        df.locale = Locale(identifier: "es-MX")
        df.dateFormat = "EEEE, MMM d"
        filterTableView.cellForRow(at: IndexPath(row: changingFilter, section: 0))?.detailTextLabel?.text = df.string(from: picker.date)
        setFilterDate = picker.date
        refreshEvents()
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        refreshEvents()
    }
    
    
    
    // MARK: - Navigation

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if(segue.identifier == "showEvent"){
            let vc = segue.destination as! EventDetailViewController
            vc.eventManager = self.eventManager
            vc.evento = filteredEvents[(eventTableView.indexPathForSelectedRow?.row)!]
            vc.favoriteListener = self
        }
    }
    
    // MARK: - Favorite Listener

    func onFavoriteChange(eventId: String, favorite: Bool) {
        for i in filteredEvents {
            if(i.eventId == eventId){
                i.favorite = favorite
                break
            }
        }
        eventTableView.reloadData()
    }
    
}
