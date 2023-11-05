//
//  SelectVerbTableViewCell.swift
//  Verregular
//
//  Created by Sviatoslav Samoilov on 28.07.2023.
//

import UIKit
import SnapKit

final class SelectVerbTableViewCell: UITableViewCell {
    enum State {
        case select, unselect
        
        var image: UIImage {
            switch self {
            case .select:
                return UIImage.checkmark
            case .unselect:
                return UIImage(systemName: "circlebadge") ?? UIImage.add
            }
        }
    }
    
    // MARK: - GUI Variables
    private lazy var checkboxImageView: UIImageView = {
        var view = UIImageView()
        view.image = State.unselect.image
        view.contentMode = .center
        return view
    }()
    
    private lazy var stackView: UIStackView = {
        let view = UIStackView()
        view.axis = .horizontal
        view.distribution = .fillEqually
        view.alignment = .center
        view.spacing = 5
        return view
    }()
    
    private lazy var infinitiveView: UIView = UIView()
    
    private lazy var infinitiveLabel: UILabel = {
        let label = UILabel()
        label.font = .boldSystemFont(ofSize: 18)
        return label
    }()
    
    private lazy var translationLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 14)
        label.textColor = .gray
        return label
    }()
    
    private lazy var pastLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 18)
        label.textAlignment = .center
        return label
    }()
    
    private lazy var participleLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 18)
        label.textAlignment = .center
        return label
    }()
    
    // MARK: - Initialization
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Methods
    func configure(with verb: Verb, isSelected: Bool) {
        infinitiveLabel.text = verb.infinitive
        translationLabel.text = verb.translation
        pastLabel.text = verb.pastSimple
        participleLabel.text = verb.participle
        checkboxImageView.image = isSelected ? State.select.image : State.unselect.image
    }
    
    // MARK: - Private methods
    func setupUI() {
        selectionStyle = .none
        infinitiveView.addSubviews([infinitiveLabel, translationLabel])
        stackView.addArrangedSubviews([infinitiveView, pastLabel, participleLabel])
        addSubviews([checkboxImageView, stackView])
        
        setupConstraints()
    }
    
    func setupConstraints() {
        checkboxImageView.snp.makeConstraints { make in
            make.width.height.equalTo(20)
            make.centerY.equalToSuperview()
            make.leading.equalToSuperview().inset(20)
        }
        
        infinitiveLabel.snp.makeConstraints { make in
            make.center.equalToSuperview()
        }
        
        translationLabel.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(infinitiveLabel.snp.bottom).offset(0)
        }
        
        infinitiveView.snp.makeConstraints { make in
            make.height.equalTo(60)
        }
        
        stackView.snp.makeConstraints { make in
            make.leading.equalTo(checkboxImageView.snp.trailing).offset(5)
            make.top.right.bottom.equalToSuperview()
        }
    }
}
