//
//  ViewController.swift
//  RxSwiftMac
//
//  Created by Harry Ng on 24/4/2016.
//  Copyright © 2016 STAY REAL LIMITED. All rights reserved.
//

import Cocoa
import RxSwift
import RxCocoa

class ViewController: NSViewController {
    
    var disposeBag = DisposeBag()

    @IBOutlet weak var textField: NSTextField!
    @IBOutlet weak var checkboxButton: NSButton!
    @IBOutlet weak var label: NSTextField!
    
    @IBOutlet weak var slider: NSSlider!
    @IBOutlet weak var sliderValue: NSTextField!
    
    @IBOutlet weak var unbindButton: NSButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        // Simple RxSwift example
        let sequence = Observable.of(1, 2, 3)
        _ = sequence
            .map { number in
                number * 2
            }
            .subscribe { print($0) }
        
        // NSTextField and NSButton example
        let textFieldSequence = textField.rx_text
        .observeOn(MainScheduler.instance)
        
        let checkboxSequence = checkboxButton.rx_state
        .observeOn(MainScheduler.instance)
        
        let result = Observable.combineLatest(textFieldSequence, checkboxSequence) { (text, state) -> String in
            if state == NSOnState {
                return text
            } else {
                return "Disabled"
            }
        }
            
        result.bindTo(label.rx_text)
        .addDisposableTo(disposeBag)
        
        // NSSlider example
        slider.rx_value
            .subscribeNext { value in
                self.sliderValue.stringValue = "\(Int(value))"
            }
            .addDisposableTo(disposeBag)
        
        sliderValue.rx_text
            .subscribeNext { value in
                let doubleValue = value.toDouble() ?? 0.0
                self.slider.doubleValue = doubleValue
                self.sliderValue.stringValue = "\(Int(doubleValue))"
            }
            .addDisposableTo(disposeBag)
        
        // Unbind everything
        unbindButton.rx_tap
            .subscribeNext { [weak self] _ in
                self?.disposeBag = DisposeBag()
            }
            .addDisposableTo(disposeBag)
    }

    override var representedObject: AnyObject? {
        didSet {
        // Update the view, if already loaded.
        }
    }


}

extension String {
    func toDouble() -> Double? {
        let numberFormatter = NSNumberFormatter()
        return numberFormatter.numberFromString(self)?.doubleValue
    }
}

