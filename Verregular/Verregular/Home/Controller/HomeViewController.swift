//
//  HomeViewController.swift
//  Verregular
//
//  Created by Sviatoslav Samoilov on 28.07.2023.
//

import UIKit
import SnapKit

class HomeViewController: UIViewController {

    // MARK: - GUI Variables
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.text = "Verregular".uppercased()
        label.font = .boldSystemFont(ofSize: 35)
        return label
    }()
    
    private lazy var firstButton: UIButton = {
        let button = UIButton()
        button.setTitle("Select verbs".localized, for: .normal)
        button.titleLabel?.font = .boldSystemFont(ofSize: 20)
        button.setTitleColor(.black, for: .normal)
        button.backgroundColor = .systemYellow
        button.layer.cornerRadius = cornerRadius
        button.addTarget(self, action: #selector(goToSelectViewController), for: .touchUpInside)
        return button
    }()
    
    private lazy var secondButton: UIButton = {
        let button = UIButton()
        button.setTitle("Train verbs".localized, for: .normal)
        button.titleLabel?.font = .boldSystemFont(ofSize: 20)
        button.setTitleColor(.black, for: .normal)
        button.backgroundColor = .systemYellow
        button.layer.cornerRadius = cornerRadius
        button.addTarget(self, action: #selector(goToTrainViewController), for: .touchUpInside)
        return button
    }()
    
    // MARK: - Properties
    private let cornerRadius: CGFloat = 15
    private let buttonHeight: CGFloat = 60
    
    // MARK: - Life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
    }
    
    // MARK: - Methods
    @objc
    private func goToSelectViewController() {
        navigationController?.pushViewController(SelectVerbsViewController(), animated: true)
    }
    
    @objc
    private func goToTrainViewController() {
        navigationController?.pushViewController(TrainViewController(), animated: true)
    }
    
    private func configureUI() {
        view.backgroundColor = .white
        view.addSubview(titleLabel)
        view.addSubview(firstButton)
        view.addSubview(secondButton)
        
        setupConstraints()
    }
    
    private func setupConstraints() {
        titleLabel.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.bottom.equalTo(firstButton.snp.top).offset(-80)
        }
        
        firstButton.snp.makeConstraints { make in
            make.center.equalToSuperview()
            make.height.equalTo(buttonHeight)
            make.leading.equalTo(80)
        }
        
        secondButton.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(firstButton.snp.bottom).offset(20)
            make.height.equalTo(buttonHeight)
            make.leading.equalTo(80)
        }
    }
}
