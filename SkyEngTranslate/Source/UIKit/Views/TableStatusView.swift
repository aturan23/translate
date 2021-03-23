//
//  TableStatusView.swift
//  SkyEngTranslate
//
//  Created by Turan Assylkhan on 23.03.2021.
//

import UIKit

class TableStatusView: UIView, LoadingFailurePresentable, ShimmeringViewPresentable {
    
    enum State: Equatable {
        case loading
        case empty(statusText: String, image: UIImage?)
        case failure(retryAction: (() -> Void))
        case filled
        
        static func == (lhs: TableStatusView.State, rhs: TableStatusView.State) -> Bool {
            switch (lhs, rhs) {
            case (.loading, .loading), (.empty, .empty), (.failure, .failure), (.filled, .filled):
                return true
            default:
                return false
            }
        }
    }
    
    // ------------------------------
    // MARK: - LoadingFailurePresentable
    // ------------------------------
    
    var loadingFailureView = LoadingFailureView()
    var state: State?
    
    // ------------------------------
    // MARK: - ShimmeringViewPresentable
    // ------------------------------
    
    var compoundShimmeringViews = UIView()
    var shimmerableOriginalViews: [UIView]?
    
    // ------------------------------
    // MARK: - Actions
    // ------------------------------
    
    func render(for state: State) {
        reset()
        self.state = state
        switch state {
        case .loading:
            renderForLoadingState()
        case .empty(let statusText, let image):
            renderForEmptyState(statusText: statusText, image: image)
        case .failure(let retryAction):
            renderForFailureState(retryAction: retryAction)
        case .filled:
            renderForFilledState()
        }
    }
    
    private func reset() {
        subviews.forEach { $0.removeFromSuperview() }
        isHidden = true
    }
    
    private func renderForLoadingState() {
        addSubview(compoundShimmeringViews)
        compoundShimmeringViews.snp.makeConstraints {
            $0.top.left.right.equalToSuperview()
        }
        startShimmering()
        isHidden = false
    }
    
    private func renderForEmptyState(statusText: String, image: UIImage?) {
        let emptyStateView = EmptyStateView(message: statusText)
        if let image = image {
            emptyStateView.set(image: image)
        }
        addSubview(emptyStateView)
        emptyStateView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        isHidden = false
    }
    
    private func renderForFailureState(retryAction: @escaping (() -> Void)) {
        loadingFailureView.retryAction = retryAction
        addSubview(loadingFailureView)
        loadingFailureView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        isHidden = false
    }
    
    private func renderForFilledState() {
        reset()
    }
}
