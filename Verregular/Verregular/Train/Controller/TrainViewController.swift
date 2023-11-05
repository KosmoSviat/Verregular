//
//  TrainViewController.swift
//  Verregular
//
//  Created by Sviatoslav Samoilov on 28.07.2023.
//

import UIKit
import SnapKit

final class TrainViewController: UIViewController {
    // MARK: - GUI Variables
    private lazy var scrollView: UIScrollView = {
        let view = UIScrollView()
        view.showsVerticalScrollIndicator = false
        return view
    }()
    
    private lazy var contentView = UIView()
    
    private lazy var scoreLabel: UILabel = {
        let label = UILabel()
        label.text = ("Scores: ".localized + String(scores)).uppercased()
        label.font = .systemFont(ofSize: 18)
        label.textColor = .black
        label.textAlignment = .center
        return label
    }()
    
    private lazy var numberVerbLabel: UILabel = {
        let label = UILabel()
        label.text = ("Verb ".localized + String(numberVerb + 1) + "/"
                      + String(IrregularVerbs.shared.selectedVerbs.count)).uppercased()
        label.font = .systemFont(ofSize: 18)
        label.textColor = .black
        label.textAlignment = .center
        return label
    }()
    
    private lazy var infinitiveLabel: UILabel = {
        let label = UILabel()
        label.text = currentVerb?.infinitive.uppercased()
        label.font = .boldSystemFont(ofSize: 35)
        label.textColor = .black
        label.textAlignment = .center
        return label
    }()
    
    private lazy var pastSimpleLabel: UILabel = {
        let label = UILabel()
        label.text = "Past simple"
        label.font = .systemFont(ofSize: 14)
        label.textColor = .gray
        return label
    }()
    
    private lazy var participleLabel: UILabel = {
        let label = UILabel()
        label.text = "Past participle"
        label.font = .systemFont(ofSize: 14)
        label.textColor = .gray
        return label
    }()
    
    private lazy var pastSimpleTextField: UITextField = {
        let field = UITextField()
        field.borderStyle = .roundedRect
        field.delegate = self
        return field
    }()
    
    private lazy var participleTextField: UITextField = {
        let field = UITextField()
        field.borderStyle = .roundedRect
        field.delegate = self
        return field
    }()
    
    private lazy var checkButton: UIButton = {
        let button = UIButton()
        button.setTitle("Check".localized, for: .normal)
        button.titleLabel?.font = .boldSystemFont(ofSize: 20)
        button.setTitleColor(.black, for: .normal)
        button.backgroundColor = .systemYellow
        button.layer.cornerRadius = 10
        button.addTarget(self, action: #selector(checkAction), for: .touchUpInside)
        return button
    }()
    
    private lazy var skipButton: UIButton = {
        let button = UIButton()
        button.setTitle("Skip".localized, for: .normal)
        button.titleLabel?.font = .boldSystemFont(ofSize: 20)
        button.setTitleColor(.black, for: .normal)
        button.backgroundColor = .systemGray5
        button.layer.cornerRadius = 10
        button.addTarget(self, action: #selector(skipAction), for: .touchUpInside)
        return button
    }()
    
    //MARK: - Properties
    private let edgeInsets: CGFloat = 30
    private let dataSource = IrregularVerbs.shared.selectedVerbs
    private var currentVerb: Verb? {
        guard dataSource.count > numberVerb else { return nil }
        return dataSource[numberVerb]
    }
    private var scores = 0 {
        didSet {
            scoreLabel.text = ("Scores: ".localized + String(scores)).uppercased()
        }
    }
    private var numberVerb = 0 {
        didSet {
            infinitiveLabel.text = currentVerb?.infinitive.uppercased()
            pastSimpleTextField.text = ""
            participleTextField.text = ""
            
            numberVerbLabel.text = ("Verb ".localized + String(numberVerb + 1) + "/"
                                    + String(IrregularVerbs.shared.selectedVerbs.count)).uppercased()
        }
    }
    
    // MARK: - Life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        hideKeyboardWhenTappedAround()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        registerForKeyboardNotification()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        unregisterForKeyboardNotification()
    }
    
    // MARK: - Methods
    private func setupUI() {
        title = "Train verbs".localized
        view.backgroundColor = .white
        view.addSubview(scrollView)
        scrollView.addSubview(contentView)
        contentView.addSubviews([scoreLabel, numberVerbLabel, infinitiveLabel, pastSimpleLabel, pastSimpleTextField,
                                 participleLabel, participleTextField, checkButton, skipButton])
        setupConstraints()
    }
    
    private func checkAnswer() -> Bool {
        guard let currentVerb = currentVerb else { return false }
        return pastSimpleTextField.text?.lowercased() == currentVerb.pastSimple.lowercased() &&
        participleTextField.text?.lowercased() == currentVerb.participle.lowercased()
    }
    
    @objc
    private func checkAction() {
        if checkAnswer() {
            scores += 1
            configureCheckButtonState(caseAnswer: "Right")
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                if self.numberVerb + 1 == IrregularVerbs.shared.selectedVerbs.count {
                    self.contentView.isHidden = true
                    self.showAlert(title: "Training is over".localized,
                                   message: "Scores received: ".localized + String(self.scores))
                }
                
                self.numberVerb += 1
                self.configureCheckButtonState(caseAnswer: "Default")
            }
        } else {
            configureCheckButtonState(caseAnswer: "Wrong")
            pastSimpleTextField.text = ""
            participleTextField.text = ""
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                self.configureCheckButtonState(caseAnswer: "Default")
            }
        }
    }
    
    @objc
    private func skipAction() {
        infinitiveLabel.text = (IrregularVerbs.shared.selectedVerbs[numberVerb].pastSimple
        + " - " + IrregularVerbs.shared.selectedVerbs[numberVerb].participle).uppercased()
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
            if self.numberVerb + 1 == IrregularVerbs.shared.selectedVerbs.count {
                self.contentView.isHidden = true
                self.showAlert(title: "Training is over".localized,
                               message: "Scores received: ".localized + String(self.scores))
            }
            self.numberVerb += 1
        }
    }
    
    private func showAlert(title: String, message: String) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .default) { _ in
            self.navigationController?.popToRootViewController(animated: true)
        }
        alertController.addAction(okAction)
        present(alertController, animated: true, completion: nil)
    }
    
    private func configureCheckButtonState(caseAnswer: String) {
        if caseAnswer == "Right" {
            checkButton.setTitle("Right".localized, for: .normal)
            checkButton.setTitleColor(.white, for: .normal)
            checkButton.backgroundColor = .systemGreen
        } else if caseAnswer == "Wrong" {
            checkButton.setTitle("Try again".localized, for: .normal)
            checkButton.setTitleColor(.white, for: .normal)
            checkButton.backgroundColor = .systemRed
        } else if caseAnswer == "Default" {
            checkButton.setTitle("Check".localized, for: .normal)
            checkButton.setTitleColor(.black, for: .normal)
            checkButton.backgroundColor = .systemYellow
        }
    }
    
    private func setupConstraints() {
        scrollView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        contentView.snp.makeConstraints { make in
            make.size.edges.equalToSuperview()
        }
        
        scoreLabel.snp.makeConstraints { make in
            make.leading.equalToSuperview().inset(edgeInsets)
            make.bottom.equalTo(infinitiveLabel.snp.top).offset(-100)
        }
        
        numberVerbLabel.snp.makeConstraints { make in
            make.trailing.equalToSuperview().inset(edgeInsets)
            make.bottom.equalTo(infinitiveLabel.snp.top).offset(-100)
        }
        
        infinitiveLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(175)
            make.trailing.leading.equalToSuperview().inset(edgeInsets)
        }
        
        pastSimpleLabel.snp.makeConstraints { make in
            make.top.equalTo(infinitiveLabel.snp.bottom).offset(100)
            make.trailing.leading.equalToSuperview().inset(edgeInsets)
        }
        
        pastSimpleTextField.snp.makeConstraints { make in
            make.top.equalTo(pastSimpleLabel.snp.bottom).offset(10)
            make.trailing.leading.equalToSuperview().inset(edgeInsets)
        }
        
        participleLabel.snp.makeConstraints { make in
            make.top.equalTo(pastSimpleTextField.snp.bottom).offset(20)
            make.trailing.leading.equalToSuperview().inset(edgeInsets)
        }
        
        participleTextField.snp.makeConstraints { make in
            make.top.equalTo(participleLabel.snp.bottom).offset(10)
            make.trailing.leading.equalToSuperview().inset(edgeInsets)
        }
        
        checkButton.snp.makeConstraints { make in
            make.top.equalTo(participleTextField.snp.bottom).offset(80)
            make.trailing.leading.equalToSuperview().inset(edgeInsets)
            make.height.equalTo(50)
        }
        
        skipButton.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(checkButton.snp.bottom).offset(20)
            make.trailing.leading.equalToSuperview().inset(edgeInsets)
            make.height.equalTo(50)
        }
    }
}

//MARK: - UITextFieldDelegate
extension TrainViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if pastSimpleTextField.isFirstResponder {
            participleTextField.becomeFirstResponder()
        } else {
            scrollView.endEditing(true)
            checkAction()
        }
        return true
    }
}

//MARK: - Keyboard events
private extension TrainViewController {
    func registerForKeyboardNotification() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(_:)),
                                               name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide),
                                               name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    func unregisterForKeyboardNotification() {
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification,
                                                  object: nil)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification,
                                                  object: nil)
    }
    
    @objc
    func keyboardWillShow(_ notification: Notification) {
        guard let frame = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect
        else { return }
        scrollView.contentInset.bottom = frame.height + 50
    }
    
    @objc
    func keyboardWillHide() {
        scrollView.contentInset.bottom = .zero - 120
    }
    
    func hideKeyboardWhenTappedAround() {
        let recognizer = UITapGestureRecognizer(target: self, action: #selector(hideKeyboard))
        scrollView.addGestureRecognizer(recognizer)
    }
    
    @objc
    func hideKeyboard() {
        scrollView.endEditing(true)
    }
}
