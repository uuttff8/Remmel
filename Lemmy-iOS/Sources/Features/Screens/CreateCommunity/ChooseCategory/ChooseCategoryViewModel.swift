//
//  ChooseCategoryViewModel.swift
//  Lemmy-iOS
//
//  Created by uuttff8 on 23.11.2020.
//  Copyright © 2020 Anton Kuzmin. All rights reserved.
//

import UIKit
import Combine

final class ChooseCategoryViewModel {
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

}
