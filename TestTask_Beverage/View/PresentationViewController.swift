//
//  PresentationViewController.swift
//  TestTask_Beverage
//
//  Created by Panchenko Oleg on 02.08.2022.
//

import AsyncDisplayKit

protocol AnyPresentationView {
    var presenter: AnyPresenter? { get set }
    func configure(with drink: Drinks)
}

class PresentationViewController: ASDKViewController<BaseNode>, AnyPresentationView {
    
    //MARK: - Properties
    var presenter: AnyPresenter?
    
    private var drinkImage: ASNetworkImageNode = {
        let image = ASNetworkImageNode()
        image.style.preferredSize = CGSize(width: K.width * 0.9, height: K.height / 2 - 40)
        image.contentMode = UIView.ContentMode.scaleAspectFill
        image.backgroundColor = .systemBackground
        image.clipsToBounds = true
        image.layer.cornerRadius = 15
        return image
    }()
    
    private var drinkName: ASTextNode = {
        let name = ASTextNode()
        name.style.preferredSize = CGSize(width: K.width, height: 20)
        name.textContainerInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        return name
    }()
    
    //MARK: - Init
    override init() {
        super.init(node: BaseNode())
        node.backgroundColor = UIColor.white
        self.node.layoutSpecBlock = { (node, constrainedSize) in
            let stack = ASStackLayoutSpec(direction: .vertical, spacing: 10, justifyContent: .start, alignItems: .center, children: [self.drinkImage, self.drinkName])
            return ASInsetLayoutSpec(insets: .init(top: 20, left: 0, bottom: K.height / 2, right: 0), child: stack)
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - Congigure
    func configure(with drink: Drinks) {
        
        guard let drinkUrl = drink.drinkImageUrl, let drinkName = drink.drinkName else { return }
        self.drinkImage.url = URL(string: drinkUrl)
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.alignment = .center
        self.drinkName.attributedText = NSAttributedString(string: drinkName,
                                                           attributes:[NSAttributedString.Key.foregroundColor: UIColor.black,
                                                                       NSAttributedString.Key.font: UIFont.systemFont(ofSize: 16, weight: .semibold),
                                                                       NSAttributedString.Key.paragraphStyle: paragraphStyle])
    }
}

