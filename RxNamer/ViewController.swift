//
//  ViewController.swift
//  RxNamer
//
//  Created by Manoj Kulkarni on 5/25/20.
//  Copyright © 2020 Manoj Kulkarni. All rights reserved.
//

import UIKit
import RxCocoa
import RxSwift

class ViewController: UIViewController {

    @IBOutlet weak var helloLabel: UILabel!
    @IBOutlet weak var nameEntryTextField: UITextField!
    @IBOutlet weak var addNameButton: UIButton!
    @IBOutlet weak var namesListLabel: UILabel!
    
    let disposeBag = DisposeBag()
    
    let namesArray: BehaviorRelay<[String]> = BehaviorRelay(value: [])
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        bindTextField()
        bindAddNameButton()
        
        namesArray.asObservable().subscribe(onNext: {names in
            self.namesListLabel.text = names.joined(separator: ", ")
            }).disposed(by: disposeBag)
    }

    func bindTextField() {
        nameEntryTextField.rx.text.map {
            if $0 == ""{
                return "Type your name below."
            }
            else {
                return "Hello \($0!)."
            }
            
        }.bind(to: helloLabel.rx.text).disposed(by: disposeBag)
    }
    
    func bindAddNameButton() {
        self.addNameButton.rx.tap.subscribe(onNext: {
            if self.nameEntryTextField.text != "" {
                self.namesArray.accept(self.namesArray.value + [self.nameEntryTextField.text!])
                self.namesListLabel.rx.text.onNext(self.namesArray.value.joined(separator: ", "))
                self.nameEntryTextField.rx.text.onNext("")
                self.helloLabel.rx.text.onNext("Type your name below.")
            }
            }).disposed(by: disposeBag)
    }
    

}

