//
//  ViewController.swift
//  StoryApp
//
//  Created by Alex Azarov on 5/9/18.
//  Copyright © 2018 Alex Azarov. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "startAdventure" {
            guard let pageController = segue.destination as? PageVC else { return }
            pageController.page = Adventure.story
        }
    }
}

