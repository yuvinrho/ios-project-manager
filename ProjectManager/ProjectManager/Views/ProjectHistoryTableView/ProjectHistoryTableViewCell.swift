//
//  ProjectHistoryTableViewCell.swift
//  ProjectManager
//
//  Created by 로빈 on 2023/01/29.
//

import UIKit

final class ProjectHistoryTableViewCell: UITableViewCell {
    // MARK: Properties
    private let historyLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 2
        label.font = .preferredFont(forTextStyle: .title1)
        return label
    }()

    private let timestampLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 1
        label.font = .preferredFont(forTextStyle: .title3)
        label.textColor = .systemGray
        return label
    }()

    private lazy var stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        stackView.distribution = .equalSpacing
        stackView.spacing = 4
        return stackView
    }()

    // MARK: Initialization
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)

        selectionStyle = .none

        configureView()
        configureConstraints()
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: Private Method
    private func configureView() {
        contentView.addSubview(stackView)

        stackView.addArrangedSubview(historyLabel)
        stackView.addArrangedSubview(timestampLabel)
    }

    private func configureConstraints() {
        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: contentView.topAnchor),
            stackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            stackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            stackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
        ])
    }

    // MARK: Internal Method
    func configure(with history: ProjectHistory) {
        let dateFormatter: DateFormatter = {
            let dateFormatter = DateFormatter()
            dateFormatter.dateStyle = .full
            dateFormatter.timeStyle = .medium
            dateFormatter.locale = .current
            return dateFormatter
        }()

        historyLabel.text = history.history
        timestampLabel.text = history.timestamp.convertToString(using: dateFormatter)
    }
}
