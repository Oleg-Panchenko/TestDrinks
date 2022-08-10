//
//  BaseNode.swift
//  TestTask_Beverage
//
//  Created by Panchenko Oleg on 30.07.2022.
//

import AsyncDisplayKit

class BaseNode: ASDisplayNode {
    
    override init() {
        super.init()
        self.automaticallyManagesSubnodes = true
    }
}
