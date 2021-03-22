//
//  LogoTableViewManager.swift
//  SkyEngTranslate
//
//  Created by Turan Assylkhan on 22.03.2021.
//

import UIKit

class LogoTableViewManager<Item: LogoCellAdapter, SectionModel: TableViewSectionModel<Item>>:
    NSObject,
    UITableViewDelegate,
    UITableViewDataSource
{
    
    // ------------------------------
    // MARK: - Properties
    // ------------------------------
    
    private var sections: [SectionModel] = []
    private weak var tableView: UITableView?
    private var onDidScrollY: ((CGFloat) -> Void)?
    
    // ------------------------------
    // MARK: - Life cycle
    // ------------------------------
    
    init(tableView: UITableView, onDidScrollY: ((CGFloat) -> Void)? = nil) {
        super.init()
        self.tableView = tableView
        self.onDidScrollY = onDidScrollY
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(LogoTableViewCell.self)
    }
    
    // ------------------------------
    // MARK: - Public methods
    // ------------------------------
    
    func display(sections: [SectionModel]) {
        self.sections = sections
    }
    
    // ------------------------------
    // MARK: - UITableViewDataSource
    // ------------------------------
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return sections.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return sections[section].items.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let adapter = sections[indexPath.section].items[indexPath.row]
        let cell: LogoTableViewCell = tableView.dequeueReusableCell(forIndexPath: indexPath)
        cell.update(for: adapter)
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return sections[section].headerHeight
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return sections[section].footerHeight
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let section = sections[section]
        let headerView = LogoTableSectionHeaderView(
            frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: section.headerHeight))
        headerView.setTitle(section.title)
        headerView.backgroundColor = section.backgroundColor
        return headerView
    }
    
    // MARK: - UITableViewDelegate
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        sections[indexPath.section].onSelection?(indexPath)
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return false
    }
    
    func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath)
        -> UITableViewCell.EditingStyle {
        return .none
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        onDidScrollY?(scrollView.contentOffset.y)
    }
}
