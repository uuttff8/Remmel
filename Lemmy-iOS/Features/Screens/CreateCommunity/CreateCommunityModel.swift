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
    
    let selectedCategory: PassthroughSubject<LemmyApiStructs.CategoryView, Never> = PassthroughSubject()
    
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
}
