//
//  Presenter.swift
//  TestTask_Beverage
//
//  Created by Panchenko Oleg on 30.07.2022.
//

import AsyncDisplayKit

protocol AnyPresenter {
    var view: AnyView? { get set }
    var presentationView: AnyPresentationView? { get set }
    var interactor: AnyInteractor? { get set }
    var router: AnyRouter? { get set }
    
    func search(drink: String)
    func present(with drinks: Drinks)
    func interactorDidFetchData(with result: Result<Coctail, Error>)
}

class BeveragePresenter: AnyPresenter {
    var view: AnyView?
    var presentationView: AnyPresentationView?
    
    var interactor: AnyInteractor?
    
    var router: AnyRouter?
    
    func search(drink: String) {
        interactor?.fetchData(searchText: drink)
    }
    
    //PresentationVC
    func present(with drinks: Drinks) {
        presentationView?.configure(with: drinks)
        view?.presentDrink(viewController: presentationView!)
    }
    
    //CoctailsVC
    func interactorDidFetchData(with result: Result<Coctail, Error>) {
        switch result {
        case .success(let beverages):
            view?.update(with: beverages)
        case .failure(let error):
            view?.update(with: error)
        }
    }
}
