//
//  JKSlider.swift
//  ExSlider
//
//  Created by 김종권 on 2022/06/01.
//

import UIKit
import SnapKit

// 1. touch 영역 정보 - begin/continue/end tracking
// 2. thumb뷰가 터치 되었는지 확인? 위 메소드에서 frame.contains로 확인
// 3. frame.contains로 특정 뷰가 터치 되었는지 확인할것이므로, 각 뷰들을 isUserInteractionEnabled = false 처리 (컨테이너로 있는 UIView만 터치 받도록 처리)

// 4. SnapKit에서 레이아웃 정의할때 .constraint로 Constraint 인스턴스를 가져와서 저장하고있고, continueTracking에서 실시간으로 Constraint의 inset을 변경

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
    view.isUserInteractionEnabled = false
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
    view.isUserInteractionEnabled = false
    return view
  }()
  private let trackView: UIView = {
    let view = UIView()
    view.backgroundColor = .gray
    view.isUserInteractionEnabled = false
    return view
  }()
  private let trackTintView: UIView = {
    let view = UIView()
    view.backgroundColor = .blue
    view.isUserInteractionEnabled = false
    return view
  }()
  
  // MARK: Properties
  var minValue = 0.0 {
    didSet { self.lower = self.minValue }
  }
  var maxValue = 10.0 {
    didSet { self.upper = self.maxValue }
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
    didSet { self.updateLayout(self.lower, true) }
  }
  private var upper = 10.0 {
    didSet { self.updateLayout(self.upper, false) }
  }
  private var previousTouchPoint = CGPoint.zero
  private var isLowerThumbViewTouched = false
  private var isUpperThumbViewTouched = false
  private var leftConstraint: Constraint?
  private var rightConstraint: Constraint?
  private var thumbViewLength: Double {
    Double(self.bounds.height)
  }
  
  // MARK: Init
  required init?(coder: NSCoder) {
    fatalError("xib is not implemented")
  }
  override init(frame: CGRect) {
    super.init(frame: frame)

    self.addSubview(self.trackView)
    self.addSubview(self.trackTintView)
    self.addSubview(self.lowerThumbView)
    self.addSubview(self.upperThumbView)
    
    self.lowerThumbView.backgroundColor = .orange
    self.upperThumbView.backgroundColor = .red
    
    self.lowerThumbView.snp.makeConstraints {
      $0.top.bottom.equalToSuperview()
      $0.width.equalTo(self.snp.height)
      $0.right.lessThanOrEqualTo(self.upperThumbView.snp.left)
      $0.left.greaterThanOrEqualToSuperview()
      self.leftConstraint = $0.left.equalToSuperview().priority(999).constraint // .constraint로 값 가져오기 테크닉
    }
    self.upperThumbView.snp.makeConstraints {
      $0.top.bottom.equalToSuperview()
      $0.width.equalTo(self.snp.height)
      $0.left.greaterThanOrEqualTo(self.lowerThumbView.snp.right)
      $0.right.lessThanOrEqualToSuperview()
      self.rightConstraint = $0.right.equalToSuperview().priority(999).constraint
    }
    self.trackView.snp.makeConstraints {
      $0.left.right.centerY.equalToSuperview()
      $0.height.equalTo(self).multipliedBy(Constant.barRatio)
    }
    self.trackTintView.snp.makeConstraints {
      $0.left.equalTo(self.lowerThumbView.snp.right)
      $0.right.equalTo(self.upperThumbView.snp.left)
      $0.top.bottom.equalTo(self.trackView)
    }
  }
  
  // MARK: Touch
  override func point(inside point: CGPoint, with event: UIEvent?) -> Bool {
    super.point(inside: point, with: event)
    return self.lowerThumbView.frame.contains(point) || self.upperThumbView.frame.contains(point)
  }
  
  override func beginTracking(_ touch: UITouch, with event: UIEvent?) -> Bool {
    super.beginTracking(touch, with: event)
    
    self.previousTouchPoint = touch.location(in: self)
    self.isLowerThumbViewTouched = self.lowerThumbView.frame.contains(self.previousTouchPoint)
    self.isUpperThumbViewTouched = self.upperThumbView.frame.contains(self.previousTouchPoint)
    
    // TODO: highlighted on
    
    return self.isLowerThumbViewTouched || self.isUpperThumbViewTouched
  }
  
  override func continueTracking(_ touch: UITouch, with event: UIEvent?) -> Bool {
    super.continueTracking(touch, with: event)
    
    let touchPoint = touch.location(in: self)
    defer {
      self.previousTouchPoint = touchPoint
      self.sendActions(for: .valueChanged)
    }
    
    let drag = Double(touchPoint.x - self.previousTouchPoint.x)
    let scale = (self.maxValue - self.minValue) * drag
    let scaledDrag = scale / Double(self.bounds.width - self.thumbViewLength) // thumbView가 움직일수 있는 영역으로 나누어주기
    
    if self.isLowerThumbViewTouched {
      self.lower = (self.lower + scaledDrag)
        .clamped(to: (self.minValue...self.upper))
    } else {
      self.upper = (self.upper + -scaledDrag)
        .clamped(to: (self.lower...self.maxValue))
    }
    return true
  }
  
  override func endTracking(_ touch: UITouch?, with event: UIEvent?) {
    super.endTracking(touch, with: event)
    self.sendActions(for: .valueChanged)
    // TODO: highlighted off
  }
  
  // MARK: Method
  private func updateLayout(_ value: Double, _ isLowerThumb: Bool) {
    print(value)
    DispatchQueue.main.async {
      let length = self.bounds.width - self.thumbViewLength
      let startValue = value - self.minValue
      let diff = self.maxValue - self.minValue
      let inset = length * startValue / diff
      
      _ = isLowerThumb
      ? self.leftConstraint?.update(inset: inset)
      : self.rightConstraint?.update(inset: inset)
    }
  }
}

final class RoundableView: UIView {
  override func layoutSubviews() {
    super.layoutSubviews()
    self.layer.cornerRadius = self.frame.height / 2
  }
}

private extension Comparable {
  func clamped(to limits: ClosedRange<Self>) -> Self {
    min(max(self, limits.lowerBound), limits.upperBound)
  }
}
