//
//  ProjectManager - ProjectListViewController.swift
//  Created by yagom. 
//  Copyright © yagom. All rights reserved.
// 

import UIKit

final class ProjectListViewController: UIViewController {
    // MARK: Properties
    private let projectManager: any CRUDable
    private var databaseManager: DatabaseManager? {
        return projectManager as? DatabaseManager
    }

    private var todoList: [Project] = [] {
        didSet {
            todoViewController.update(with: todoList)
        }
    }

    private var doingList: [Project] = [] {
        didSet {
            doingViewController.update(with: doingList)
        }
    }

    private var doneList: [Project] = [] {
        didSet {
            doneViewController.update(with: doneList)
        }
    }

    private lazy var todoViewController = ProjectTableViewController(status: .todo,
                                                                tableView: ProjectTableView(),
                                                                delegate: self)
    private lazy var doingViewController = ProjectTableViewController(status: .doing,
                                                                 tableView: ProjectTableView(),
                                                                 delegate: self)
    private lazy var doneViewController = ProjectTableViewController(status: .done,
                                                                tableView: ProjectTableView(),
                                                                delegate: self)

    private let stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .horizontal
        stackView.alignment = .fill
        stackView.distribution = .fillEqually
        stackView.spacing = 10
        return stackView
    }()

    // MARK: View Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()

        configureNavigationBar()
        fetchProjectList()
        addChildViewControllers()
        configureView()
        configureConstraints()
        updateChildViewController()
    }

    init(projectManager: any CRUDable) {
        self.projectManager = projectManager
        super.init(nibName: nil, bundle: nil)
    }

    @available (*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func presentProjectViewController() {
        let project = Project(status: .todo, title: "제목없음", description: " ", dueDate: Date())
        let projectViewController = ProjectViewController(with: project, mode: .add, delegate: self)

        present(UINavigationController(rootViewController: projectViewController), animated: false)
    }

    private func makeRightNavigationBarButton() -> UIBarButtonItem {
        let touchUpAddButtonAction = UIAction { [weak self] _ in
            self?.presentProjectViewController()
        }

        let addButton = UIBarButtonItem(systemItem: .add, primaryAction: touchUpAddButtonAction)

        return addButton
    }

    private func configureNavigationBar() {
        navigationItem.title = "Project Manager"
        navigationItem.rightBarButtonItem = makeRightNavigationBarButton()
    }

    private func createDummyProject() {
        guard let databaseManager = projectManager as? DatabaseManager else {
            fatalError("데이터베이스 매니저가 없음")
        }

        DummyProjects.projects.forEach {
            databaseManager.create(data: $0) { result in
                switch result {
                case .success(_):
                    print("성공")
                case .failure(let error):
                    print(error.localizedDescription)
                }
            }
        }
    }

    private func fetchProjectList() {
        fetchProjectList(status: .todo)
        fetchProjectList(status: .doing)
        fetchProjectList(status: .done)
    }

    private func fetchProjectList(status: ProjectStatus) {
        databaseManager?.read(status: status) { result in
            switch result {
            case .success(let fetchedData):
                print("인터넷연결됨")
                switch status {
                case .todo:
                    self.todoList = fetchedData
                case .doing:
                    self.doingList = fetchedData
                case .done:
                    self.doneList = fetchedData
                }
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }

    private func addChildViewControllers() {
        [todoViewController, doingViewController, doneViewController].forEach {
            addChild($0)
        }
    }

    private func configureView() {
        view.addSubview(stackView)

        children.forEach {
            stackView.addArrangedSubview($0.view)
        }
    }

    private func configureConstraints() {
        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            stackView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            stackView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            stackView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
        ])
    }

    private func updateChildViewController() {
        children.forEach {
            guard let childViewController = $0 as? ProjectTableViewController else {
                return
            }

            switch childViewController.status {
            case .todo:
                childViewController.update(with: todoList)
            case .doing:
                childViewController.update(with: doingList)
            case .done:
                childViewController.update(with: doneList)
            }
        }
    }
}

// MARK: Project Delegate
extension ProjectListViewController: ProjectDelegate {
    func create(project: Project) {
       // databaseManager?.create(data: project)
        fetchProjectList()
    }

    func update(project: Project) {
       // databaseManager?.update(data: project)
        fetchProjectList()
    }

    func delete(project: Project) {
       // databaseManager?.delete(data: project)
        fetchProjectList()
    }
}
