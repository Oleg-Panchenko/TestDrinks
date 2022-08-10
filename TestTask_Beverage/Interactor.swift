//
//  Interactor.swift
//  TestTask_Beverage
//
//  Created by Panchenko Oleg on 30.07.2022.
//

import Foundation
import Alamofire

protocol AnyInteractor {
    var presenter: AnyPresenter? { get set }
    func fetchData(searchText: String)
}

class BeverageInteractor: AnyInteractor {
    var presenter: AnyPresenter?
    
    func fetchData(searchText: String) {
        
        let urlAPI = "https://www.thecocktaildb.com/api/json/v1/1/search.php"
        let parameters = ["s": searchText]
        
        AF.request(urlAPI, method: .get, parameters: parameters, encoder: .urlEncodedForm, headers: nil, interceptor: nil, requestModifier: nil).responseData { [weak self] (dataResponse) in
            
            if let error = dataResponse.error {
                print("Error received requesting data: \(error.localizedDescription)")
                self?.presenter?.interactorDidFetchData(with: .failure(error))
                return
            }
            
            guard let data = dataResponse.data else { return }
            let decoder = JSONDecoder()
            
            do {
                let drinks = try decoder.decode(Coctail.self, from: data)
                self?.presenter?.interactorDidFetchData(with: .success(drinks))
            } catch let jsonError {
                print("Failed to decode JSON", jsonError)
                self?.presenter?.interactorDidFetchData(with: .failure(jsonError))
            }
        }
    }
}
