//
//  ViewController.swift
//  ExSlider
//
//  Created by 김종권 on 2022/06/01.
//

import UIKit
import SnapKit

class ViewController: UIViewController {
  private let slider: JKSlider = {
    let slider = JKSlider()
    slider.minValue = 1
    slider.maxValue = 100
    slider.lower = 1
    slider.upper = 75
    slider.addTarget(self, action: #selector(changeValue), for: .valueChanged)
    return slider
  }()
  private let label: UILabel = {
    let label = UILabel()
    label.font = .systemFont(ofSize: 20)
    label.numberOfLines = 0
    label.translatesAutoresizingMaskIntoConstraints = false
    return label
  }()
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    self.view.addSubview(self.slider)
    self.view.addSubview(self.label)
    
    self.slider.snp.makeConstraints {
      $0.height.equalTo(40)
      $0.width.equalTo(300)
      $0.center.equalToSuperview()
    }
    self.label.snp.makeConstraints {
      $0.top.equalToSuperview().inset(80)
      $0.centerX.equalToSuperview()
    }
  }
  
  @objc private func changeValue() {
    self.label.text = "\(Int(self.slider.lower)) ~ \(Int(self.slider.upper))"
  }
}
