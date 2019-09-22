//
//  ViewController.swift
//  rxnamer
//
//  Created by nagas on 9/22/19.
//  Copyright © 2019 nagas. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
class ViewController: UIViewController {

    @IBOutlet weak var helloLbl: UILabel!
    @IBOutlet weak var nameEntryTxtField: UITextField!
    @IBOutlet weak var submitBtn: UIButton!
    @IBOutlet weak var namesLbl: UILabel!
    
    
    var disposeBag = DisposeBag()
    var namesArray: Variable<[String]> = Variable([])
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        bindTextField()
        bindSubmitBtn()
        bindAddNamebtn()
        
        namesArray.asObservable().subscribe(onNext: { (name) in
            self.namesLbl.text = name.joined(separator: ", ")
        }, onError: { (error) in
            
        }, onCompleted: {
            
        }) {
            
        }
            
//            .subscribe({ names in
//            self.namesLbl.textInputMode = names.joined(separator: ", ")
//        })
    }

    func bindTextField(){
        nameEntryTxtField.rx.text
//            .debounce(0.5, scheduler: MainScheduler.instance)
            .debounce(RxTimeInterval.milliseconds(500), scheduler: MainScheduler.instance)
            .map{
                if $0 == "" {
                    return "Enter your name below"
                } else {
                    return "Hello \($0!)"
                }
               
            }
            .bind(to: helloLbl.rx.text)
            .disposed(by: disposeBag)
    }
    
    func bindSubmitBtn(){
        submitBtn.rx.tap.subscribe(onNext: {
            if self.nameEntryTxtField.text != "" {
                self.namesArray.value.append(self.nameEntryTxtField.text!)
                self.namesLbl.rx.text.onNext(self.namesArray.value.joined(separator: ", "))
                self.nameEntryTxtField.rx.text.onNext("")
                self.helloLbl.rx.text.onNext("Enter your name below")
            }
        }).disposed(by: disposeBag)
    }
    @IBOutlet weak var addNameBtn: UIButton!
    
    func bindAddNamebtn(){
        addNameBtn.rx.tap.throttle(RxTimeInterval.milliseconds(500), scheduler: MainScheduler.instance).subscribe(onNext: {
            guard let addNameVC = self.storyboard?.instantiateViewController(withIdentifier: "AddNameVC") as? AddNameVC else {fatalError ("cound not create AddNameVC")}
            addNameVC.nameSubject.subscribe(onNext: { name in
                self.namesArray.value.append(name)
                addNameVC.dismiss(animated: true, completion: nil)
                
            })
                .disposed(by: self.disposeBag)
            self.present(addNameVC,animated: true,completion: nil)
        })
    }
}

