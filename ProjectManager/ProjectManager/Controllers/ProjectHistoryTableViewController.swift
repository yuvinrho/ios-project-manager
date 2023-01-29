//
//  ProjectHistoryTableViewController.swift
//  ProjectManager
//
//  Created by 로빈 on 2023/01/29.
//

import UIKit

final class ProjectHistoryTableViewController: UITableViewController {
    typealias DataSource = UITableViewDiffableDataSource<Int, ProjectHistory>
    typealias Snapshot = NSDiffableDataSourceSnapshot<Int, ProjectHistory>

    private var history: [ProjectHistory] = []
    private let historyManager = HistoryManager()
    private lazy var dataSource = makeDataSource()

    override func viewWillAppear(_ animated: Bool){
        super.viewDidLoad()

        fetchHistories()
    }

    // MARK: Initialization
    init(tableView: UITableView) {
        super.init(nibName: nil, bundle: nil)

        self.tableView = tableView
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: Data Source
    private func makeDataSource() -> DataSource {
        let dataSource = DataSource(tableView: tableView) { tableView, indexPath, history in
            guard let cell = tableView.dequeueReusableCell(withIdentifier: ProjectHistoryTableViewCell.reuseIdentifier) as? ProjectHistoryTableViewCell else {
                return UITableViewCell()
            }

            cell.configure(with: history)

            return cell
        }

        return dataSource
    }

    private func configureSnapshot(items: [ProjectHistory]) {
        var snapshot = Snapshot()
        snapshot.appendSections([0])
        // 최근 히스토리가 맨 위에 오도록 reversed()함
        snapshot.appendItems(items.reversed())

        dataSource.apply(snapshot)
    }

    private func fetchHistories() {
        historyManager.read() { result in
            switch result {
            case .success(let fetchedData):
                self.history = fetchedData
                self.configureSnapshot(items: self.history)
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }

    private func deleteHistory(_ history: ProjectHistory) {
        historyManager.delete(data: history) { result in
            switch result {
            case .success(_):
                self.fetchHistories()
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }

    func addHistory(_ history: ProjectHistory) {
        historyManager.create(data: history) { result in
            switch result {
            case .success(_):
                return
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
}

extension ProjectHistoryTableViewController {
    override func tableView(_ tableView: UITableView,
                   trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath
    ) -> UISwipeActionsConfiguration? {
        let targetHistory = history[indexPath.row]
        let deleteAction = UIContextualAction(style: .destructive, title: nil) { [weak self] (_, _, success) in
            self?.deleteHistory(targetHistory)
            success(true)
        }

        deleteAction.title = "삭제"

        return UISwipeActionsConfiguration(actions: [deleteAction])
    }
}
