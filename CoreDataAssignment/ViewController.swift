//
//  ViewController.swift
//  CoreDataAssignment
//
//  Created by Apple on 12/02/22.
//

import UIKit

class ViewController: UIViewController {

    var data = DataLoader().userData
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        print("poki  \(data)")
    }


}

