//
//  ToDoTableViewCell.swift
//  ToDoApp
//
//  Created by Никита Павлов on 02.08.2025.
//

import UIKit
import SnapKit

final class ToDoTableViewCell: UITableViewCell {
    var onToggleStatus: (() -> Void)?
    
    //MARK: - UI
    private let titleLabel = UILabel()
    private let descriptionLabel = UILabel()
    private let dateLabel = UILabel()
    private let statusView = UIImageView()

    //MARK: - Init
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(didTapStatus))
        statusView.isUserInteractionEnabled = true
        statusView.addGestureRecognizer(tapGesture)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - Setup UI
    private func setupUI() {
        backgroundColor = .clear
        selectionStyle = .none
        
        titleLabel.font = UIFont.systemFont(ofSize: 16, weight: .semibold)
        
        descriptionLabel.font = UIFont.systemFont(ofSize: 12)
        descriptionLabel.numberOfLines = 2
        
        dateLabel.font = UIFont.systemFont(ofSize: 12)
        dateLabel.textColor = .stroke
        
        statusView.layer.cornerRadius = 5
        statusView.clipsToBounds = true
        
        let labelsStack = UIStackView(arrangedSubviews: [
            titleLabel,
            descriptionLabel,
            dateLabel
        ])
        labelsStack.axis = .vertical
        labelsStack.spacing = 6
        labelsStack.alignment = .leading
        labelsStack.distribution = .fillProportionally
        
        contentView.addSubview(statusView)
        contentView.addSubview(labelsStack)
        
        statusView.snp.makeConstraints {
            $0.width.height.equalTo(24)
            $0.top.equalToSuperview().inset(12)
            $0.leading.equalToSuperview().offset(20)
        }
        labelsStack.snp.makeConstraints {
            $0.top.bottom.equalToSuperview().inset(12)
            $0.leading.equalTo(statusView.snp.trailing).offset(8)
            $0.trailing.equalToSuperview().inset(20)
        }
    }
    
    //MARK: - Actions
    @objc private func didTapStatus() {
        onToggleStatus?()
    }
    
    //MARK: - Public
    func configure(title: String, description: String, date: String, isDone: Bool) {
        if isDone {
            let attributedTitle = NSAttributedString(
                string: title,
                attributes: [
                    .strikethroughStyle: NSUnderlineStyle.single.rawValue,
                    .foregroundColor: UIColor.stroke
                ]
            )
            titleLabel.attributedText = attributedTitle
            descriptionLabel.textColor = .stroke
            statusView.image = UIImage(systemName: "checkmark.circle")
            statusView.tintColor = .yellowApp
        } else {
            titleLabel.attributedText = NSAttributedString(string: title)
            titleLabel.textColor = .white
            descriptionLabel.textColor = .white
            statusView.image = UIImage(systemName: "circle")
            statusView.tintColor = .stroke
        }
        
        descriptionLabel.text = description
        dateLabel.text = date
    }
}
