//
//  ProjectHistoryTableView.swift
//  ProjectManager
//
//  Created by 로빈 on 2023/01/29.
//

import UIKit

final class ProjectHistoryTableView: UITableView {
    override init(frame: CGRect, style: UITableView.Style) {
        super.init(frame: frame, style: style)

        register(ProjectHistoryTableViewCell.self, forCellReuseIdentifier: ProjectHistoryTableViewCell.reuseIdentifier)
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
