//
//  ViewController.swift
//  RxNamer
//
//  Created by nag on 22/09/2017.
//  Copyright © 2017 Anton Novoselov. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class ViewController: UIViewController {
    
    @IBOutlet weak var helloLbl: UILabel!
    @IBOutlet weak var nameEntryTextField: UITextField!
    @IBOutlet weak var submitBtn: UIButton!
    @IBOutlet weak var namesLbl: UILabel!
    @IBOutlet weak var addNameBtn: UIButton!
    
    let disposeBag = DisposeBag()
    
    var namesArray: Variable<[String]> = Variable([])

    override func viewDidLoad() {
        super.viewDidLoad()
        bindTextField()
        bindSubmitButton()
        bindAddNameButton()
        
        namesArray.asObservable()
            .subscribe(onNext: { names in
                self.namesLbl.text = names.joined(separator: ", ")
            })
            .addDisposableTo(disposeBag)
    }
    
    func bindTextField() {
        nameEntryTextField.rx.text
//            .debounce(0.5, scheduler: MainScheduler.instance)
            .map {
                if $0 == "" {
                    return "Type your name below."
                } else {
                    return "Hello, \($0!)."
                }
            }
            .bind(to: helloLbl.rx.text)
            .addDisposableTo(disposeBag)
    }
    
    
    func bindSubmitButton() {
        submitBtn.rx.tap
            .subscribe(onNext: {
                if self.nameEntryTextField.text != "" {
                    self.namesArray.value.append(self.nameEntryTextField.text!)
                    self.namesLbl.rx.text.onNext(self.namesArray.value.joined(separator: ", "))
                    self.nameEntryTextField.rx.text.onNext("")
                    self.helloLbl.rx.text.onNext("Type your name below")
                }
            })
            .addDisposableTo(disposeBag)
    }
    
    
    func bindAddNameButton() {
        addNameBtn.rx.tap
            .throttle(0.5, scheduler: MainScheduler.instance)
            .subscribe(onNext: {
                
                guard let addNameVC = self.storyboard?.instantiateViewController(withIdentifier: "AddNameVC") as? AddNameVC else { fatalError("Could not create AddNameVC") }
                
                addNameVC.nameSubject
                    .subscribe(onNext: { name in
                        self.namesArray.value.append(name)
                        addNameVC.dismiss(animated: true, completion: nil)
                    })
                    .addDisposableTo(self.disposeBag)
                self.present(addNameVC, animated: true, completion: nil)
            })
    }
    

}










