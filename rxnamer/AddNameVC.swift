//
//  AddNameVCViewController.swift
//  rxnamer
//
//  Created by nagas on 9/22/19.
//  Copyright © 2019 nagas. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class AddNameVC: UIViewController {

    
    let nameSubject = PublishSubject<String>()
    
    @IBOutlet weak var nameTxtField: UITextField!
    @IBOutlet weak var newNameTxtField: UIStackView!
    @IBOutlet weak var submitBtn: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        bindSubmitBtn ()
        // Do anybindSubmitBtn () additional setup after loading the view.
    }
    
    func bindSubmitBtn (){
        submitBtn.rx.tap.subscribe(onNext: {
            if self.nameTxtField.text != "" {
                self.nameSubject.onNext(self.nameTxtField.text!)
            }
            
        })
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
