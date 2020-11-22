//
//  CreateCommunityModel.swift
//  Lemmy-iOS
//
//  Created by uuttff8 on 28.10.2020.
//  Copyright © 2020 Anton Kuzmin. All rights reserved.
//

import UIKit
import Combine

protocol CreateCommunityViewModelProtocol: AnyObject {
    func doCreateCommunityFormLoad(request: CreateCommunity.CreateCommunityFormLoad.Request)
}

class CreateCommunityViewModel: CreateCommunityViewModelProtocol {
    
    weak var viewController: CreateCommunityViewControllerProtocol?
    
    struct CreateCommunityData {
        let name: String
        let title: String
        let description: String?
        let icon: String?
        let banner: String?
        let categoryId: Int?
        let nsfwOption: Bool
    }
    
    let categories: CurrentValueSubject<[LemmyModel.CategoryView], Never> = CurrentValueSubject([])
    let filteredCategories: CurrentValueSubject<[LemmyModel.CategoryView], Never> = CurrentValueSubject([])

    let selectedCategory: CurrentValueSubject<LemmyModel.CategoryView?, Never> = CurrentValueSubject(nil)

    func loadCategories() {
        ApiManager.requests.listCategoties(parameters: LemmyModel.Site.ListCategoriesRequest()) { (res) in
            switch res {
            case let .success(response):
                self.categories.send(response.categories)
            case let .failure(error):
                print(error.localizedDescription)
            }
        }
    }

    func searchCategories(query: String) {
        let filtered = categories.value.filter { (categor) -> Bool in
            categor.name.contains(query)
        }

        filteredCategories.send(filtered)
    }

//    func createCommunity(
//        data: CreateCommunityModel.CreateCommunityData,
//        completion: @escaping ((Result<LemmyModel.CommunityView, LemmyGenericError>) -> Void)
//    ) {
//        guard let jwtToken = LemmyShareData.shared.jwtToken
//        else {
//            completion(.failure(.string("Not logined")))
//            return
//        }
//
//        let params = LemmyModel.Community.CreateCommunityRequest(name: data.name,
//                                                                      title: data.title,
//                                                                      description: data.description,
//                                                                      icon: data.icon,
//                                                                      banner: data.banner,
//                                                                      categoryId: data.categoryId ?? 1,
//                                                                      nsfw: data.nsfwOption,
//                                                                      auth: jwtToken)
//
//        ApiManager.requests.createCommunity(parameters: params) { (res) in
//            switch res {
//            case let .success(response):
//                completion(.success(response.community))
//            case let .failure(error):
//                print(error)
//                completion(.failure(error))
//            }
//        }
//    }
    
    func doCreateCommunityFormLoad(request: CreateCommunity.CreateCommunityFormLoad.Request) {
        self.viewController?.displayCreateCommunityForm(viewModel: .init())
    }
}
