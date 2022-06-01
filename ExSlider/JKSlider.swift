//
//  JKSlider.swift
//  ExSlider
//
//  Created by 김종권 on 2022/06/01.
//

import UIKit
import SnapKit

final class JKSlider: UIControl {
  // MARK: Constant
  private enum Constant {
    static let barHeight = 8.0
    static let thumbLength = barHeight * 5
  }
  
  // MARK: UI
  private let lowerThumbView: RoundableView = {
    let view = RoundableView()
    view.backgroundColor = .white
    view.layer.shadowOffset = CGSize(width: 0, height: 3)
    view.layer.shadowColor = UIColor.black.cgColor
    view.layer.shadowOpacity = 0.3
    view.layer.borderWidth = 1.0
    view.layer.borderColor = UIColor.gray.withAlphaComponent(0.1).cgColor
    return view
  }()
  private let upperThumbView: RoundableView = {
    let view = RoundableView()
    view.backgroundColor = .white
    view.layer.shadowOffset = CGSize(width: 0, height: 3)
    view.layer.shadowColor = UIColor.black.cgColor
    view.layer.shadowOpacity = 0.3
    view.layer.borderWidth = 1.0
    view.layer.borderColor = UIColor.gray.withAlphaComponent(0.1).cgColor
    return view
  }()
  private let trackView: UIView = {
    let view = UIView()
    view.backgroundColor = .gray
    return view
  }()
  private let trackTintView: UIView = {
    let view = UIView()
    view.backgroundColor = .blue
    return view
  }()
  
  // MARK: Properties
  var min = 0.0
  var max = 10.0
  var lowerThumbColor = UIColor.white {
    didSet { self.lowerThumbView.backgroundColor = self.lowerThumbColor }
  }
  var upperThumbColor = UIColor.white {
    didSet { self.upperThumbView.backgroundColor = self.upperThumbColor }
  }
  var trackColor = UIColor.gray {
    didSet { self.trackView.backgroundColor = self.trackColor }
  }
  var trackTintColor = UIColor.blue {
    didSet { self.trackTintView.backgroundColor = self.trackTintColor }
  }
  
  private var lower = 0.0 {
    didSet {
      self.sendActions(for: .valueChanged)
    }
  }
  private var upper = 10.0 {
    didSet {
      self.sendActions(for: .valueChanged)
    }
  }
  
  required init?(coder: NSCoder) {
    fatalError("xib is not implemented")
  }
  override init(frame: CGRect) {
    super.init(frame: frame)
    
    self.addSubview(self.trackView)
    self.trackView.addSubview(self.trackTintView)
    self.trackView.addSubview(self.lowerThumbView)
    self.trackView.addSubview(self.upperThumbView)

    self.trackView.snp.makeConstraints {
      $0.left.right.equalToSuperview()
      $0.centerY.equalToSuperview()
      $0.height.equalTo(Constant.barHeight)
    }
    self.trackTintView.snp.makeConstraints {
      $0.left.equalTo(self.lowerThumbView.snp.right)
      $0.right.equalTo(self.upperThumbView.snp.left)
      $0.centerY.equalToSuperview()
      $0.height.equalTo(Constant.barHeight)
    }
    self.lowerThumbView.snp.makeConstraints {
      $0.left.equalToSuperview()
      $0.top.greaterThanOrEqualToSuperview()
      $0.bottom.lessThanOrEqualToSuperview()
      $0.size.equalTo(Constant.thumbLength)
    }
    self.upperThumbView.snp.makeConstraints {
      $0.right.equalToSuperview()
      $0.top.greaterThanOrEqualToSuperview()
      $0.bottom.lessThanOrEqualToSuperview()
      $0.size.equalTo(Constant.thumbLength)
    }
  }
  
  override func continueTracking(_ touch: UITouch, with event: UIEvent?) -> Bool {
    super.continueTracking(touch, with: event)
    print(touch.location(in: self))
    
    return true
  }
}

final class RoundableView: UIView {
  override func layoutSubviews() {
    super.layoutSubviews()
    self.layer.cornerRadius = self.frame.height / 2
  }
}
