//
//  CoctailsViewController.swift
//  TestTask_Beverage
//
//  Created by Panchenko Oleg on 30.07.2022.
//

import AsyncDisplayKit

protocol AnyView {
    var presenter: AnyPresenter? { get set }
    func update(with drinks: Coctail)
    func update(with error: Error)
    func presentDrink(viewController: AnyPresentationView)
}

class CoctailsViewController: ASDKViewController<BaseNode>, AnyView {
    
    //MARK: - Properties
    private var collectionNode: ASCollectionNode = {
        let flowLayout = UICollectionViewFlowLayout()
        flowLayout.scrollDirection = .vertical
        flowLayout.minimumLineSpacing = 10
        let collectionNode = ASCollectionNode(collectionViewLayout: flowLayout)
        collectionNode.style.preferredSize = CGSize(width: UIScreen.main.bounds.width, height: 400)
        collectionNode.view.translatesAutoresizingMaskIntoConstraints = false
        collectionNode.backgroundColor = .systemBackground
        collectionNode.view.allowsSelection = true
        return collectionNode
    }()
    
    private var searchTextField: UITextField = {
        let bounds = UIScreen.main.bounds
        let textField = UITextField()
        textField.frame = CGRect(x: bounds.width / 2 - 175, y: bounds.height - 200, width: 350, height: 30)
        textField.textAlignment = .center
        textField.font = UIFont.systemFont(ofSize: 15, weight: .medium)
        textField.placeholder = "Coctail Name"
        textField.clipsToBounds = true
        textField.layer.masksToBounds = false
        textField.backgroundColor = .white
        textField.layer.cornerRadius = 10
        textField.layer.shadowColor = UIColor.lightGray.cgColor
        textField.layer.shadowRadius = 5
        textField.layer.shadowOpacity = 0.8
        textField.layer.shadowOffset = CGSize(width: 2.5, height: 2.5)
        return textField
    }()
    
    private var spinner: UIActivityIndicatorView = {
        let spinner = UIActivityIndicatorView()
        spinner.hidesWhenStopped = true
        return spinner
    }()
    
    var presenter: AnyPresenter?
    private var timer: Timer!
    private var tapGesture: UITapGestureRecognizer!
    
    private var beverages: Coctail?
    
    //MARK: - Init
    override init() {
        super.init(node: BaseNode())
        node.backgroundColor = .systemBackground
        self.node.layoutSpecBlock = { (node, constrainedSize) in
            return ASInsetLayoutSpec(insets: .init(top: 0, left: 10, bottom: 300, right: 10), child: self.collectionNode)
        }
    }
    
    //MARK: - ViewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(searchTextField)
        view.addSubview(spinner)
        spinner.center = view.center
        collectionNode.dataSource = self
        collectionNode.delegate = self
        searchTextField.delegate = self
        registerKeyboardNotification()
        configureTapGesture()
    }
    
    deinit {
        removeKeyboardNotification()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - Update Collection
    func update(with drinks: Coctail) {
        beverages = drinks
        spinner.stopAnimating()
        collectionNode.reloadData()
    }
    
    func update(with error: Error) {
        let alert = UIAlertController(title: "Warning!", message: "Beverage is not found.", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Ok", style: .default))
        present(alert, animated: true)
        print(error.localizedDescription)
    }
    
    //MARK: - Present Drink
    func presentDrink(viewController: AnyPresentationView) {
        guard let vc = viewController as? PresentationViewController else { return }
        if let sheet = vc.sheetPresentationController {
            sheet.detents = [.medium()]
            sheet.prefersGrabberVisible = true
            sheet.prefersEdgeAttachedInCompactHeight = false
            sheet.preferredCornerRadius = 20
            }
        present(vc, animated: true)
    }
    
    //MARK: - Gesture
    private func configureTapGesture() {
        tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleTap))
        view.addGestureRecognizer(tapGesture)
    }
    
    @objc private func handleTap() {
        view.endEditing(true)
    }
}

//MARK: - ASCollectionDataSource
extension CoctailsViewController: ASCollectionDataSource, ASCollectionDelegate {
    
    func collectionNode(_ collectionNode: ASCollectionNode, numberOfItemsInSection section: Int) -> Int {
        return beverages?.drinks.count ?? 0
    }
    
    func collectionNode(_ collectionNode: ASCollectionNode, nodeForItemAt indexPath: IndexPath) -> ASCellNode {
        let model = beverages?.drinks[indexPath.row]
        let cell = SearchCoctailsCell(text: model?.drinkName ?? "")
        return cell
    }
    
    //MARK: - ASCollectionDelegate
    func collectionNode(_ collectionNode: ASCollectionNode, constrainedSizeForItemAt indexPath: IndexPath) -> ASSizeRange {
        return ASSizeRangeMake(CGSize(width: 20, height: 20), CGSize(width: CGFloat.greatestFiniteMagnitude, height: 40))
    }
    
    func collectionNode(_ collectionNode: ASCollectionNode, didSelectItemAt indexPath: IndexPath) {
        let drink = beverages?.drinks[indexPath.row]
        guard let drink = drink else { return }
        presenter?.present(with: drink)
    }
}

//MARK: - UITextFieldDelegate
extension CoctailsViewController: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        searchTextField.endEditing(true)
    }
    
    func textFieldDidChangeSelection(_ textField: UITextField) {
        let drink = textField.text ?? ""
        guard !drink.isEmpty else { return }
        spinner.startAnimating()
        timer?.invalidate()
        timer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: false, block: { (_) in
            self.presenter?.search(drink: drink)
        })
    }
}

//MARK: - Notification Keyboard Show/Hide
extension CoctailsViewController {
    
    private func registerKeyboardNotification() {
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(keyboardWillShow),
                                               name: UIResponder.keyboardWillShowNotification,
                                               object: nil)
        
        NotificationCenter.default.addObserver(self,
                                           selector: #selector(keyboardWillHide),
                                           name: UIResponder.keyboardWillHideNotification,
                                           object: nil)
    }
    
    private func removeKeyboardNotification() {
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    @objc private func keyboardWillShow(notification: Notification) {
        let userInfo = notification.userInfo
        let keyboardFrame = (userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as! NSValue).cgRectValue
        let newTextFieldHeight = (K.height - (keyboardFrame.height / 2) - 198)
        searchTextField.frame = CGRect(x: 0, y: newTextFieldHeight, width: K.width, height: 30)
        searchTextField.layer.cornerRadius = 0
        tapGesture.isEnabled = true
    }
    
    @objc private func keyboardWillHide(notification: Notification) {
        searchTextField.frame = CGRect(x: K.width / 2 - 175, y: K.height - 200, width: 350, height: 30)
        searchTextField.layer.cornerRadius = 10
        tapGesture.isEnabled = false
    }
}
