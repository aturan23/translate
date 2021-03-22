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
}
