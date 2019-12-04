//
//  ChangeCityViewController.swift
//  openWeather
//
//  Created by Karlis Cars on 28/11/2019.
//  Copyright © 2019 Karlis Cars. All rights reserved.
//

import UIKit

protocol ChangeCityDelegate {
    func userEnteredaNewCityName(city: String)
    
}

class ChangeCityViewController: UIViewController {

    var delegate: ChangeCityDelegate?
    
    @IBOutlet weak var changeCityText: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    @IBAction func getWeatherButton(_ sender: Any) {
        let cityName = changeCityText.text!
        delegate?.userEnteredaNewCityName(city: cityName)
        dismiss(animated: true, completion: nil)
    }
    
    

}
