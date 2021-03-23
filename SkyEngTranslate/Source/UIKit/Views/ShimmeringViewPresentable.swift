//
//  ShimmeringViewPresentable.swift
//  SkyEngTranslate
//
//  Created by Turan Assylkhan on 23.03.2021.
//

import UIKit

protocol ShimmeringViewPresentable: class {
    var compoundShimmeringViews: UIView { get }
    var shimmerableOriginalViews: [UIView]? { get }
    func startShimmering()
    func stopShimmering()
}

extension ShimmeringViewPresentable where Self: UIViewController {
    func startShimmering() {
        shimmerableOriginalViews?.forEach { $0.isHidden = true }
        compoundShimmeringViews.isHidden = false
        view.bringSubviewToFront(compoundShimmeringViews)
    }
    
    func stopShimmering() {
        shimmerableOriginalViews?.forEach { $0.isHidden = false }
        compoundShimmeringViews.isHidden = true
    }
}

extension ShimmeringViewPresentable where Self: UIView {
    func startShimmering() {
        shimmerableOriginalViews?.forEach { $0.isHidden = true }
        compoundShimmeringViews.isHidden = false
        bringSubviewToFront(compoundShimmeringViews)
    }
    
    func stopShimmering() {
        shimmerableOriginalViews?.forEach { $0.isHidden = false }
        compoundShimmeringViews.isHidden = true
    }
}
