//
//  ViewController.swift
//  Unify
//
//  Created by Chrishon Wyllie on 12/10/17.
//  Copyright © 2017 Chrishon Wyllie. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    lazy var openCameraButton: UIButton = {
        let btn = UIButton(type: .system)
        btn.translatesAutoresizingMaskIntoConstraints = false
        btn.setTitle("Open Canera", for: .normal)
        btn.setTitleColor(UIColor.red, for: .normal)
        btn.clipsToBounds = true
        btn.layer.cornerRadius = 8
        btn.addTarget(self, action: #selector(openCamera(_:)), for: .touchUpInside)
        return btn
    }()
    
    @objc private func openCamera(_ sender: Any) {
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

