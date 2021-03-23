//
//  MainPageViewController.swift
//  SkyEngTranslate
//
//  Created by Turan Assylkhan on 22/03/2021.
//  Copyright © 2021 Assylkhan Turan. All rights reserved.
//

import UIKit
import SnapKit

class MainPageViewController: BaseViewController, MainPageViewInput {

    enum Constants {
        static let tableViewEstimatedRowHeight: CGFloat = 72
        static let continueButtonHiddenInset: CGFloat = -100
    }
    
    // ------------------------------
    // MARK: - Properties
    // ------------------------------

    var output: MainPageViewOutput?
    private var searchBtnBottomConstraint: Constraint?
    private lazy var tableViewManager = LogoTableViewManager<
        WordsCellAdapter,
        WordsSectionModel>(tableView: tableView)

    // ------------------------------
    // MARK: - UI components
    // ------------------------------

    private let textField = TextFieldView(title: "Слово", editingActions: [.paste, .copy])
    private lazy var tableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .grouped)
        tableView.estimatedRowHeight = Constants.tableViewEstimatedRowHeight
        tableView.separatorStyle = .none
        let emptyView = UIView(frame: CGRect.zero)
        tableView.tableFooterView = emptyView
        tableView.showsVerticalScrollIndicator = false
        tableView.backgroundColor = .clear
        tableView.estimatedSectionFooterHeight = CGFloat.leastNormalMagnitude
        tableView.keyboardDismissMode = .onDrag
        return tableView
    }()
    private lazy var tableStatusView: TableStatusView = {
        let view = TableStatusView()
        view.compoundShimmeringViews = {
            let view = StackContainerView()
            view.add(view: makeShimmeringSectionHeaderView())
            for i in 0..<10 {
                view.add(view: makeShimmeringCellsView())
            }
            return view
        }()
        return view
    }()
    private lazy var searchButton: Button = {
        let button = Button.makePrimary(with: "Поиск")
        button.touchUpInside = { [weak self] in
            self?.output?.didTapSearchButton()
        }
        return button
    }()
    
    // ------------------------------
    // MARK: - Life cycle
    // ------------------------------

    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        output?.didLoad()
    }

    // ------------------------------
    // MARK: - MainPageViewInput
    // ------------------------------
    
    func showTableLoadingState() {
        tableStatusView.render(for: .loading)
    }
    
    func showTableFailureState() {
        tableStatusView.render(for: .failure(retryAction: output?.didTapRetryButton ?? {}))
    }

    func display(viewAdapter: MainPageViewAdapter) {
        tableViewManager.display(sections: viewAdapter.sectionModels)
        tableView.reloadData()
        setupFor(isEmpty: viewAdapter.sectionModels.isEmpty)
    }
    
    func showInputError(message: String) {
        textField.showError(message: message)
    }
    
    func endEditing() {
        view.endEditing(true)
    }
    
    func getFieldText() -> String {
        textField.getText()
    }

    // ------------------------------
    // MARK: - Private methods
    // ------------------------------
    
    private func setupFor(isEmpty: Bool) {
        let state: TableStatusView.State = isEmpty
            ? .empty(statusText: "Здесь будут отображаться переводы слов",
                     image: Asset.iconNoData.image)
            : .filled
        tableStatusView.render(for: state)
    }

    private func setupViews() {
        view.backgroundColor = Color.backgroundMain
        tableStatusView.backgroundColor = Color.backgroundMain

        setupViewsHierarchy()
        setupConstraints()
    }

    private func setupViewsHierarchy() {
        [textField, tableView, tableStatusView, searchButton].forEach(view.addSubview(_:))
    }

    private func setupConstraints() {
        textField.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide).offset(LayoutGuidance.offsetThreeQuarters * 2)
            $0.left.right.equalToSuperview().inset(LayoutGuidance.offset)
        }
        tableView.snp.makeConstraints {
            $0.top.equalTo(textField.snp.bottom)
            $0.width.equalToSuperview()
            $0.bottom.equalToSuperview()
        }
        tableStatusView.snp.makeConstraints {
            $0.top.equalTo(tableView)
            $0.left.right.bottom.equalTo(view.safeAreaLayoutGuide)
        }
        searchButton.snp.makeConstraints {
            $0.left.right.equalToSuperview().inset(LayoutGuidance.offset)
            searchBtnBottomConstraint = $0.bottom.equalToSuperview()
                .inset(Constants.continueButtonHiddenInset).constraint
        }
    }
    
    private func moveButton(bottomInset: CGFloat) {
        let animations = { [weak self] in
            self?.searchBtnBottomConstraint?.update(inset: bottomInset)
            self?.view.layoutIfNeeded()
        }
        let animator = UIViewPropertyAnimator(duration: 0.5, dampingRatio: 0.9, animations: {
            animations()
        })
        animator.startAnimation()
    }
    
    private func makeShimmeringSectionHeaderView() -> UIView {
        let view = UIView()
        let titleView = ShimmeringView()
        view.addSubview(titleView)
        titleView.snp.makeConstraints { (make) in
            make.height.equalTo(12)
            make.width.equalTo(90)
            make.left.equalToSuperview().offset(16)
            make.top.equalToSuperview().offset(14)
            make.bottom.equalToSuperview().offset(-6)
        }
        return view
    }
    
    private func makeShimmeringCellsView() -> UIView {
        let view = UIView()
        let imageView = ShimmeringView(cornerRadius: 15)
        let titleView = ShimmeringView()
        let subtitleView = ShimmeringView()
        [imageView, titleView, subtitleView]
            .forEach(view.addSubview(_:))
        imageView.snp.makeConstraints { (make) in
            make.size.equalTo(40)
            make.top.left.equalToSuperview().offset(16)
            make.bottom.equalToSuperview().offset(-16)
        }
        titleView.snp.makeConstraints { (make) in
            make.top.equalToSuperview().offset(18)
            make.width.equalTo(73)
            make.height.equalTo(16)
            make.left.equalTo(imageView.snp.right).offset(16)
        }
        subtitleView.snp.makeConstraints { (make) in
            make.top.equalTo(titleView.snp.bottom).offset(10)
            make.width.equalTo(93)
            make.height.equalTo(12)
            make.left.equalTo(imageView.snp.right).offset(16)
        }
        return view
    }
}

// ------------------------------
// MARK: - KeyboardListening
// ------------------------------

extension MainPageViewController: KeyboardListening {
    
    func keyboardWillShow(notification: NSNotification) {
        guard let info = notification.userInfo,
            let keyboardFrame: NSValue = info[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue
            else { return }
        let keyboardRectangle = keyboardFrame.cgRectValue
        let keyboardHeight = keyboardRectangle.height
        if textField.isFirstResponder {
            moveButton(bottomInset: LayoutGuidance.offsetHalf + keyboardHeight)
        }
        UIView.animate(withDuration: 0.3) { [weak self] in
            self?.tableStatusView.alpha = 0
        }
    }
    
    func keyboardWillHide(notification: NSNotification) {
        moveButton(bottomInset: Constants.continueButtonHiddenInset)
        if tableStatusView.state != .filled {
            UIView.animate(withDuration: 0.3) { [weak self] in
                self?.tableStatusView.alpha = 1
            }
        }
    }
}
