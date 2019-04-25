//
//  SearchViewController.swift
//  ProyectoFinal
//
//  Created by Andrés Sánchez on 4/8/19.
//  Copyright © 2019 Martín Gerardo Moreno Barrera. All rights reserved.
//

import UIKit

class SearchViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UIPickerViewDataSource, UIPickerViewDelegate {

    @IBOutlet weak var filterTableView: UITableView!
    @IBOutlet weak var eventTableView: UITableView!
    
    @IBOutlet weak var picker: UIPickerView!
    @IBOutlet weak var datePicker: UIDatePicker!
    
    var pickerDefaultY : CGFloat = CGFloat(0)
    var filteredEvents = [1, 2, 3]
    var filters = ["Ambito", "Discapacidad", "Fecha"]
    var filterData = [
        ["ambito", "ambito111", "222lmaaa"],
        ["hehe", "hoho", "lmao"]
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
//            cell.ivFavorite.image = UIImage(named: event.favorite ? "star_gold" : "star_gray")
            cell.ivFavorite.image = UIImage(named: "star_gray")
            cell.tfTitle.text = "Test"
            
            let dateFormatterGet = DateFormatter()
            dateFormatterGet.dateFormat = "dd/MMM/YY"
            cell.tfDate.text = dateFormatterGet.string(from: Date())
            return cell
        }
    }
    
    
    // MARK: Picker
    
    @objc func hidePickers(){
//        UIView.animate(withDuration: 0.5) {
//            self.picker.frame.origin.y = self.view.bounds.size.height+250
//        }
        picker.isHidden = true
        datePicker.isHidden = true
        filterTableView.deselectRow(at: IndexPath(row: changingFilter, section: 0), animated: true)
    }
    
    func showDatePicker(){
        datePicker.isHidden = false
    }
    
    func showPicker(data : [String]){
//        UIView.animate(withDuration: 0.5) {
//            self.picker.frame.origin.y = self.pickerDefaultY
//
//            self.view.layoutIfNeeded()
//        }
//        self.view.layoutIfNeeded()
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
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return pickerData[row]
    }
    
    @IBAction func datePickerChanged(_ picker: UIDatePicker) {
        let df = DateFormatter()
        df.dateFormat = "dd/MMM/YY"
        filterTableView.cellForRow(at: IndexPath(row: changingFilter, section: 0))?.detailTextLabel?.text = df.string(from: picker.date)
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
