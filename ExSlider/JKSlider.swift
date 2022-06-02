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
    static let barRatio = 1.0/9.0
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
  var min = 0.0 {
    didSet { self.lower = self.min }
  }
  var max = 10.0 {
    didSet { self.upper = self.max }
  }
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
    
    self.lowerThumbView.backgroundColor = .orange
    self.upperThumbView.backgroundColor = .red
    
    self.lowerThumbView.snp.makeConstraints {
      $0.top.bottom.left.equalTo(self)
      $0.width.equalTo(self.snp.height)
    }
    self.upperThumbView.snp.makeConstraints {
      $0.top.bottom.right.equalTo(self)
      $0.width.equalTo(self.snp.height)
    }
    self.trackView.snp.makeConstraints {
      $0.left.right.centerY.equalTo(self)
      $0.height.equalTo(self).multipliedBy(Constant.barRatio)
    }
    self.trackTintView.snp.makeConstraints {
      $0.left.equalTo(self.lowerThumbView.snp.right)
      $0.right.equalTo(self.upperThumbView.snp.left)
      $0.top.bottom.equalTo(self.trackView)
    }
  }
  
  override func beginTracking(_ touch: UITouch, with event: UIEvent?) -> Bool {
    super.beginTracking(touch, with: event)
    
    let beginTouchPoint = touch.location(in: self)
    
    let isLowerThumbViewTouched = self.lowerThumbView.frame.contains(beginTouchPoint)
    let isUpperThumbViewTouched = self.upperThumbView.frame.contains(beginTouchPoint)
    
    return isLowerThumbViewTouched || isUpperThumbViewTouched
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
