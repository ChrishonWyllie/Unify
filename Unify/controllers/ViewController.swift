//
//  ViewController.swift
//  Unify
//
//  Created by Chrishon Wyllie on 12/10/17.
//  Copyright © 2017 Chrishon Wyllie. All rights reserved.
//

import UIKit
import Security

class ViewController: UIViewController {
    
    private var screenshotsTakenBefore: Bool? = nil

    private var usernameKey: String = ""
    private var passwordKey: String = ""
    
    private var usernameField: UITextField = {
        let txt = UITextField()
        txt.translatesAutoresizingMaskIntoConstraints = false
        txt.placeholder = "Username"
        return txt
    }()
    
    private var passwordField: UITextField = {
        let txt = UITextField()
        txt.translatesAutoresizingMaskIntoConstraints = false
        txt.placeholder = "Password"
        txt.isSecureTextEntry = true
        return txt
    }()
    
    private var explanationLabel: UILabel = {
        let lbl = UILabel()
        lbl.translatesAutoresizingMaskIntoConstraints = false
        lbl.text = "Please Enter a username and password for your images and then open the camera"
        lbl.textColor = UIColor.lightGray
        lbl.numberOfLines = 0
        return lbl
    }()
    
    private lazy var openCameraButton: UIButton = {
        let btn = UIButton(type: .system)
        btn.translatesAutoresizingMaskIntoConstraints = false
        btn.setTitle("Open Canera", for: .normal)
        btn.setTitleColor(UIColor.red, for: .normal)
        btn.clipsToBounds = true
        btn.layer.cornerRadius = 8
        btn.backgroundColor = UIColor.white
        btn.layer.borderColor = UIColor.groupTableViewBackground.cgColor
        btn.layer.borderWidth = 2
        btn.addTarget(self, action: #selector(openCamera(_:)), for: .touchUpInside)
        return btn
    }()
    
    @objc private func openCamera(_ sender: Any) {
        
        print("Attempting to open camera")
        // Check that this has not been done before
        screenshotsTakenBefore = UserDefaults.standard.value(forKey: "SecurityImagesCaptured") as? Bool
        
        if screenshotsTakenBefore == false {
            
            guard let username = usernameField.text, username != "", let password = passwordField.text, password != "" else {
                print("Cannot have empty fields")
                return
            }
            save(username: username, AndPassword: password)
            
            let cameraViewController = CameraViewController()
            self.present(cameraViewController, animated: true, completion: nil)
        } else if screenshotsTakenBefore == true {
            explanationLabel.text = "You have already taken your photographs"
            
        }
    }
    
    private func setupUIElements() {
        
        view.addSubview(usernameField)
        view.addSubview(passwordField)
        view.addSubview(explanationLabel)
        view.addSubview(openCameraButton)
        
        usernameField.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        
        passwordField.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        passwordField.topAnchor.constraint(equalTo: usernameField.bottomAnchor, constant: 40).isActive = true
        
        
        openCameraButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        openCameraButton.widthAnchor.constraint(equalToConstant: 160).isActive = true
        openCameraButton.heightAnchor.constraint(equalToConstant: 60).isActive = true
        
        if #available(iOS 11.0, *) {
            usernameField.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 80).isActive = true
            
            openCameraButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -80).isActive = true
            
            explanationLabel.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 20).isActive = true
            explanationLabel.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -20).isActive = true
        } else {
            // Fallback on earlier versions
            usernameField.topAnchor.constraint(equalTo: view.topAnchor, constant: 80).isActive = true
            
            openCameraButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -80).isActive = true
            
            explanationLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20).isActive = true
            explanationLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20).isActive = true
        }
        
        explanationLabel.bottomAnchor.constraint(equalTo: openCameraButton.topAnchor, constant: -16).isActive = true
        
        // For restarting...
        UserDefaults.standard.set(false, forKey: "SecurityImagesCaptured")
        
    }
    
    private func save(username: String, AndPassword password: String) {
        
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        setupUIElements()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

