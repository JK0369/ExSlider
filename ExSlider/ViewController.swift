//
//  ViewController.swift
//  ExSlider
//
//  Created by 김종권 on 2022/06/01.
//

import UIKit

class ViewController: UIViewController {
  private let slider: JKSlider = {
    let slider = JKSlider()
    slider.translatesAutoresizingMaskIntoConstraints = false
    return slider
  }()
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    self.view.addSubview(self.slider)
    
    NSLayoutConstraint.activate([
      self.slider.heightAnchor.constraint(equalToConstant: 40),
      self.slider.widthAnchor.constraint(equalToConstant: 200),
      self.slider.centerYAnchor.constraint(equalTo: self.view.centerYAnchor),
      self.slider.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
    ])
  }
}
