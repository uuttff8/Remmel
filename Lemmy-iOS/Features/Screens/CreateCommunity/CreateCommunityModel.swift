//
//  CreateCommunityModel.swift
//  Lemmy-iOS
//
//  Created by uuttff8 on 28.10.2020.
//  Copyright © 2020 Anton Kuzmin. All rights reserved.
//

import UIKit
import Combine

class CreateCommunityModel {
    let categories: CurrentValueSubject<[LemmyApiStructs.CategoryView], Never> = CurrentValueSubject([])
    let filteredCategories: CurrentValueSubject<[LemmyApiStructs.CategoryView], Never> = CurrentValueSubject([])
    
    let selectedCategory: CurrentValueSubject<LemmyApiStructs.CategoryView?, Never> = CurrentValueSubject(nil)
    
    func loadCategories() {
        ApiManager.requests.listCategoties(parameters: LemmyApiStructs.Site.ListCategoriesRequest())
        { (res) in
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
    
    func createCommunity(
        name: String,
        title: String,
        description: String?,
        icon: String?,
        banner: String?,
        categoryId: Int?,
        nsfwOption: Bool,
        completion: @escaping ((Result<LemmyApiStructs.CommunityView, Error>) -> Void)
    ) {
        guard let jwtToken = LemmyShareData.shared.jwtToken else { completion(.failure("Not logined")); return }
        
        let params = LemmyApiStructs.Community.CreateCommunityRequest(name: name,
                                                                      title: title,
                                                                      description: description,
                                                                      icon: icon,
                                                                      banner: banner,
                                                                      categoryId: categoryId ?? 1,
                                                                      nsfw: nsfwOption,
                                                                      auth: jwtToken)
        
        
        
        ApiManager.requests.createCommunity(parameters: params)
        { (res) in
            switch res {
            case let .success(response):
                completion(.success(response.community))
            case let .failure(error):
                print(error)
                completion(.failure(error))
            }
        }
    }

}
