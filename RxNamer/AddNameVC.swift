//
//  AddNameVC.swift
//  RxNamer
//
//  Created by nag on 22/09/2017.
//  Copyright © 2017 Anton Novoselov. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class AddNameVC: UIViewController {
    
    @IBOutlet weak var newNameTextField: UITextField!
    @IBOutlet weak var submitBtn: UIButton!
    
    let disposeBag = DisposeBag()
    
    let nameSubject = PublishSubject<String>()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        bindSubmitButton()
        
    }

    func bindSubmitButton() {
        submitBtn.rx.tap
            .subscribe(onNext: {
                if self.newNameTextField.text != "" {
                    self.nameSubject.onNext(self.newNameTextField.text!)
                }
            })
            .disposed(by: disposeBag)
    }
    

}






