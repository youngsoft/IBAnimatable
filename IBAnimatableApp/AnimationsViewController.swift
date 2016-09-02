//
//  AnimationsViewController.swift
//  IBAnimatableApp
//
//  Created by jason akakpo on 12/07/16.
//  Copyright © 2016 Jake Lin. All rights reserved.
//

import UIKit
import IBAnimatable

private let wayParam = 	ParamType(fromEnum: AnimationType.Way.self)
private let directionParam = ParamType(fromEnum: AnimationType.Direction.self)
private let fadeWayParams = ParamType(fromEnum: AnimationType.FadeWay.self)
private let axisParams = ParamType(fromEnum: AnimationType.Axis.self)
private let rotationDirectionParams = ParamType(fromEnum: AnimationType.RotationDirection.self)
private let positiveNumberParam = ParamType.number(min: 0, max: 50, interval: 2, ascending: true, unit:"")
private let numberParam = ParamType.number(min: -50, max: 50, interval: 5, ascending: true, unit: "")

class AnimationsViewController: UIViewController {
  
  @IBOutlet weak var aView: AnimatableView!
  @IBOutlet weak var pickerView: UIPickerView!
  
  
  // prebuit common params
  let entries: [PickerEntry] = [
    PickerEntry(params: [wayParam, directionParam], name: "slide"),
    PickerEntry(params: [wayParam, directionParam], name: "squeeze"),
    PickerEntry(params: [fadeWayParams], name: "fade"),
    PickerEntry(params: [wayParam, directionParam], name: "slideFade"),
    PickerEntry(params: [wayParam, directionParam], name: "squeezeFade"),
    PickerEntry(params: [wayParam], name: "zoom"),
    PickerEntry(params: [wayParam], name: "zoomInvert"),
    PickerEntry(params: [axisParams], name: "flip"),
    PickerEntry(params: [], name: "flash"),
    PickerEntry(params: [], name: "wobble"),
    PickerEntry(params: [], name: "swing"),
    PickerEntry(params: [rotationDirectionParams], name: "rotate"),
    PickerEntry(params: [positiveNumberParam, positiveNumberParam], name: "moveby"),
    PickerEntry(params: [numberParam, numberParam], name: "moveto")
    ]
  
  
  var selectedEntry: PickerEntry!
  override func viewDidLoad() {
  
    super.viewDidLoad()
    selectedEntry = entries[0]
    pickerView.dataSource = self
    pickerView.delegate = self
  }
  
}

extension AnimationsViewController : UIPickerViewDelegate, UIPickerViewDataSource {
  
  func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
    if component == 0 {
      return entries.count
    }
    return selectedEntry.params[safe: component - 1]?.count() ?? 0
  }
  
  func numberOfComponents(in pickerView: UIPickerView) -> Int {
    return 3
  }
  func pickerView(_ pickerView: UIPickerView, widthForComponent component: Int) -> CGFloat {
    switch component {
    case 0:
      return self.view.frame.size.width * 0.5
    case 1:
      return self.view.frame.size.width * 0.25
    case 2:
      return self.view.frame.size.width * 0.25
    default:
      return 0
    }
  }
  func pickerView(_ pickerView: UIPickerView, attributedTitleForRow row: Int, forComponent component: Int) -> NSAttributedString? {
    
    if component == 0 {
      return entries[safe: row]?.name.colorize(.white)
    }
    guard let param = selectedEntry.params[safe: component - 1] else {
      return nil
    }
    return param.titleAt(row).colorize(.white)
  }
  func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
    if component == 0 {
      if selectedEntry.name != entries[row].name {
        selectedEntry = entries[row]
        pickerView.reloadComponent(1)
        pickerView.reloadComponent(2)
      }
    }
    let animString = selectedEntry.toString(selectedIndexes: pickerView.selectedRow(inComponent: 1), pickerView.selectedRow(inComponent: 2))
    let animType = AnimationType(string: animString)
    pickerView.isUserInteractionEnabled = false
    aView.animate(animation: animType) {
      if #available(iOS 10.0, *) {
        if !self.aView.transform.isIdentity {
          Timer.scheduledTimer(withTimeInterval: 0.2, repeats: false) { timer in
            self.aView.alpha = 1
            self.aView.transform = CGAffineTransform.identity
            self.pickerView.isUserInteractionEnabled = true
          }
        } else {
          self.pickerView.isUserInteractionEnabled = true
        }
      }
    }
    
  }
  
}
