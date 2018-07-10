//
//  ViewController.swift
//  ios_bp_swift4
//
//  Created by R@M on 10/07/18.
//  Copyright © 2018 2Fit. All rights reserved.
//

import UIKit

class BPHomeViewController: UIViewController {

    let vm = BPHomeViewModel()

    override func viewDidLoad() {
        super.viewDidLoad()
        vm.profile({
            print(self.vm.ipAddress.value)
        }) { (error) in
            print(error)
        }
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}
