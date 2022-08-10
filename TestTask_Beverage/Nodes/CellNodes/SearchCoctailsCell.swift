//
//  SearchBeveragesCell.swift
//  TestTask_Beverage
//
//  Created by Panchenko Oleg on 30.07.2022.
//

import AsyncDisplayKit

class SearchCoctailsCell: BaseCellNode {
    
    private var textNode: ASTextNode!
    
    init(text: String) {
        textNode = ASTextNode()
        let titleParagraphStyle = NSMutableParagraphStyle()
        titleParagraphStyle.alignment = .center
        textNode.attributedText = NSAttributedString(string: text, attributes: [NSAttributedString.Key.foregroundColor: UIColor.white,
                                                                                NSAttributedString.Key.font: UIFont.systemFont(ofSize: 15, weight: .regular),
                                                                                NSAttributedString.Key.paragraphStyle: titleParagraphStyle])
        textNode.textContainerInset = UIEdgeInsets(top: 0, left: 5, bottom: 0, right: 5)
        textNode.cornerRadius = 8
        textNode.clipsToBounds = true
        textNode.backgroundColor = .lightGray
    }
    
    override func layoutSpecThatFits(_ constrainedSize: ASSizeRange) -> ASLayoutSpec {
        return ASInsetLayoutSpec(insets: .zero, child: textNode)
    }
}
