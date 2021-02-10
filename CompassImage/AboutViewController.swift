//
//  AboutViewController.swift
//  CompassImage
//
//  Created by Ben Swift on 2/10/21.
//

import Cocoa

class AboutViewController: NSViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do view setup here.
    }
    
    @IBAction func doneButtonAction(_ sender: Any) {
        self.dismiss(AboutViewController.self)
    }
    
}
