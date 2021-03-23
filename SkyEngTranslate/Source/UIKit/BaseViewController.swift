//
//  BaseViewController.swift
//  SkyEngTranslate
//
//  Created by Turan Assylkhan on 22.03.2021.
//

import UIKit

class BaseViewController: UIViewController {
    
    var safeAreaTopInset: CGFloat {
        return view.window?.windowScene?.statusBarManager?.statusBarFrame.height ?? 0
            + UINavigationController().navigationBar.bounds.height
    }
    
    var safeAreaBottomInset: CGFloat {
        return UIApplication.shared.windows.filter {$0.isKeyWindow}.first?.safeAreaInsets.bottom ?? 0
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        addKeyboardObserverIfNeeded()
        hideKeyboardWhenTappedAround()
    }
    
    private func addKeyboardObserverIfNeeded() {
        guard let listening = self as? KeyboardListening else {
            return
        }
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(listening.keyboardWillShow),
            name: UIResponder.keyboardWillShowNotification,
            object: nil
        )
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(listening.keyboardWillHide),
            name: UIResponder.keyboardWillHideNotification,
            object: nil
        )
    }
    
    private func hideKeyboardWhenTappedAround() {
        let tap = UITapGestureRecognizer(
            target: self,
            action: #selector(dismissKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
}
