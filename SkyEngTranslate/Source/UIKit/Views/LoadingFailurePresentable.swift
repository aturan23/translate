//
//  LoadingFailurePresentable.swift
//  SkyEngTranslate
//
//  Created by Turan Assylkhan on 23.03.2021.
//

import UIKit

protocol LoadingFailurePresentable: class {
    var loadingFailureView: LoadingFailureView { get }
    func showLoadingFailureState()
    func hideLoadingFailureState()
}


extension LoadingFailurePresentable where Self: UIViewController {
    func showLoadingFailureState() {
        loadingFailureView.isHidden = false
        view.bringSubviewToFront(loadingFailureView)
    }
    
    func hideLoadingFailureState() {
        loadingFailureView.isHidden = true
    }
}

extension LoadingFailurePresentable where Self: UIView {
    func showLoadingFailureState() {
        loadingFailureView.isHidden = false
        bringSubviewToFront(loadingFailureView)
    }
    
    func hideLoadingFailureState() {
        loadingFailureView.isHidden = true
    }
}
