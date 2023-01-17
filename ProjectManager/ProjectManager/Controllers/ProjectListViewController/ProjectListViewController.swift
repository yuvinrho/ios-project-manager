//
//  ProjectManager - ProjectListViewController.swift
//  Created by yagom. 
//  Copyright © yagom. All rights reserved.
// 

import UIKit

final class ProjectListViewController: UIViewController {
    typealias DataSource = UITableViewDiffableDataSource<Int, Project>
    typealias Snapshot = NSDiffableDataSourceSnapshot<Int, Project>

    // MARK: Properties
    let projectManager = ProjectManager()
    var projectList: [Project] = DummyProjects.projects
    var todoList: [Project] {
        return projectList.filter{ $0.status == .todo }
    }

    var doingList: [Project] {
        return projectList.filter{ $0.status == .doing }
    }

    var doneList: [Project] {
        return projectList.filter{ $0.status == .done }
    }

    lazy var projectListView: ProjectListView = {
        let view = ProjectListView(frame: view.bounds)
        view.autoresizingMask = [.flexibleHeight, .flexibleWidth]
        return view
    }()

    var todoDataSource: DataSource?
    var doingDataSource: DataSource?
    var doneDataSource: DataSource?

    // MARK: View Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()

        configureNavigationBar()
        configureView()
        configureDataSource()
        configureSnapshots()
    }

    // MARK: Configure NavigationBar
    private func makeRightNavigationBarButton() -> UIBarButtonItem {
        let touchUpAddButtonAction = UIAction { [weak self] _ in
            self?.present(ProjectViewController(), animated: false)
        }

        let addButton = UIBarButtonItem(systemItem: .add, primaryAction: touchUpAddButtonAction)

        return addButton
    }

    private func configureNavigationBar() {
        navigationItem.title = "프로젝트 매니저"
        navigationItem.rightBarButtonItem = makeRightNavigationBarButton()
    }

    // MARK: Configure View
    private func configureView() {
        view.addSubview(projectListView)
        configureProjectTableViewDelegate()
        configureLongPressGesture()
    }
}