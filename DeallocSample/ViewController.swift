//
//  ViewController.swift
//  DeallocSample
//
//  Created by Aaron Connolly on 5/27/21.
//

import UIKit

class ViewController: UIViewController {
    init(
        _ title: String = "White",
        _ color: UIColor = .white
    ) {
        super.init(nibName: nil, bundle: nil)
        self.title = title
        view.backgroundColor = color
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

