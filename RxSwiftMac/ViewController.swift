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
    
    let disposeBag = DisposeBag()

    @IBOutlet weak var textField: NSTextField!
    @IBOutlet weak var checkboxButton: NSButton!
    
    @IBOutlet weak var label: NSTextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        let sequence = Observable.of(1, 2, 3)
        _ = sequence
            .map { number in
                number * 2
            }
            .subscribe { print($0) }
        
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
    }

    override var representedObject: AnyObject? {
        didSet {
        // Update the view, if already loaded.
        }
    }


}

