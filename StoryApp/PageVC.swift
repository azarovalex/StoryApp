//
//  PageVC.swift
//  StoryApp
//
//  Created by Alex Azarov on 5/9/18.
//  Copyright © 2018 Alex Azarov. All rights reserved.
//

import UIKit

extension NSAttributedString {
    var stringRange: NSRange {
        return NSMakeRange(0, self.length)
    }
}

extension Story {
    var attributedText: NSAttributedString {
        let attributedString = NSMutableAttributedString(string: text)
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineSpacing = 10
        attributedString.addAttribute(NSAttributedStringKey.paragraphStyle, value: paragraphStyle, range: attributedString.stringRange)
        return attributedString
    }
}

extension Page {
    func string(attributed: Bool) -> NSAttributedString {
        if attributed {
            return story.attributedText
        } else {
            return NSAttributedString(string: story.text)
        }
    }
}

class PageVC: UIViewController {

    var page: Page?
    
    lazy var artworkView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.image = page?.story.artwork
        return imageView
    }()
    
    lazy var storyLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 0
        label.attributedText = page?.string(attributed: true)
        return label
    }()
    
    lazy var firstChoiceButton: UIButton = {
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        
        let title = page?.firstChoice?.title ?? "Play Again!"
        let selector = (page?.firstChoice != nil) ?  #selector(loadFirstChoice) : #selector(playAgain)
        
        button.setTitle(title, for: .normal)
        button.addTarget(self, action: selector, for: .touchUpInside)

        return button
    }()
    
    lazy var secondChoiceButton: UIButton = {
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        
        button.setTitle(page?.secondChoice?.title, for: .normal)
        button.addTarget(self, action: #selector(loadSecondChoice), for: .touchUpInside)
        
        return button
    }()
    
    var aProperty = {}
    
    init(page: Page) {
        self.page = page
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        
        view.addSubview(artworkView)
        NSLayoutConstraint.activate([
            artworkView.topAnchor.constraint(equalTo: view.topAnchor),
            artworkView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            artworkView.rightAnchor.constraint(equalTo: view.rightAnchor),
            artworkView.leftAnchor.constraint(equalTo: view.leftAnchor)
        ])
        
        view.addSubview(storyLabel)
        NSLayoutConstraint.activate([
                storyLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
                storyLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
                storyLabel.topAnchor.constraint(equalTo: view.centerYAnchor, constant: -48)
        ])
        
        view.addSubview(firstChoiceButton)
        NSLayoutConstraint.activate([
            firstChoiceButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            firstChoiceButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -80)
        ])
        
        view.addSubview(secondChoiceButton)
        NSLayoutConstraint.activate([
            secondChoiceButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            secondChoiceButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -32)
        ])
    }
    
    @objc func loadFirstChoice() {
        if let page = page, let firstChoice = page.firstChoice {
            let nextPage = firstChoice.page
            let pageVC = PageVC(page: nextPage)
            
            navigationController?.pushViewController(pageVC, animated: true)
        }
    }
    
    @objc func loadSecondChoice() {
        if let page = page, let secondChoice = page.secondChoice {
            let nextPage = secondChoice.page
            let pageVC = PageVC(page: nextPage)
            
            navigationController?.pushViewController(pageVC, animated: true)
        }
    }
    
    @objc func playAgain() {
        navigationController?.popToRootViewController(animated: true)
    }
}
