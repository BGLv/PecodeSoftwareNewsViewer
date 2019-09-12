//
//  SelectCountryViewController.swift
//  PecodeSoftwareNewsViewer
//
//  Created by Bogdan Lviv on 9/12/19.
//  Copyright © 2019 Bogdan Lviv. All rights reserved.
//

import UIKit

class SelectCountryViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {

    @IBOutlet weak var pickerView: UIPickerView!
   
    var pickerViewInfoArray = [""]
    var pickerViewSelectedCountry = ""
    var completion: ((String) -> Void)?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        pickerView.delegate=self
        pickerView.dataSource=self
        
        if let indexDefaultPickerElement = pickerViewInfoArray.firstIndex(of: pickerViewSelectedCountry){
            pickerView.selectRow(indexDefaultPickerElement, inComponent: 0, animated: true)
            
        }
        
        // Do any additional setup after loading the view.
    }
    

    

    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return pickerViewInfoArray.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return pickerViewInfoArray[row]
    }
    
    
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if let completion = completion{
                completion(self.pickerViewInfoArray[row])
        }
        
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
