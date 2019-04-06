//
//  ViewController.swift
//  osrm-ios-example
//
//  Created by hardsetting on 18/07/2018.
//  Copyright © 2018 twistedmirror. All rights reserved.
//

import UIKit
import Osrm
import OsrmDirections

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        let path = Bundle.main.path(forResource: "sassuolo/sassuolo", ofType: "osrm")
        
        let manager = OsrmManager.init(forMapData: path)        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

