//
//  Router.swift
//  TestTask_Beverage
//
//  Created by Panchenko Oleg on 30.07.2022.
//

import AsyncDisplayKit

typealias EntryPoint = AnyView & ASDKViewController<BaseNode>

protocol AnyRouter {
    var entry: EntryPoint? { get }
    
    static func start() -> AnyRouter
}

class UserRouter: AnyRouter {
    var entry: EntryPoint?
    
    static func start() -> AnyRouter {
        let router = UserRouter()
        
        //Asign VIP
        var view: AnyView = CoctailsViewController()
        var presentationView: AnyPresentationView = PresentationViewController()
        var interactor: AnyInteractor = BeverageInteractor()
        var presenter: AnyPresenter = BeveragePresenter()
        
        view.presenter = presenter
        presentationView.presenter = presenter
        
        interactor.presenter = presenter
        
        presenter.router = router
        presenter.view = view
        presenter.presentationView = presentationView
        presenter.interactor = interactor
        
        router.entry = view as? EntryPoint
        
        return router
    }
}
