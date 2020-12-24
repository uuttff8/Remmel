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

    private var cancellabes = Set<AnyCancellable>()
    
    func loadCategories() {
        ApiManager.requests.asyncListCategories(parameters: LemmyModel.Site.ListCategoriesRequest())
            .receive(on: DispatchQueue.main)
            .sink { (completion) in
                Logger.logCombineCompletion(completion)
            } receiveValue: { (response) in
                self.categories.send(response.categories)
            }.store(in: &cancellabes)

    }

    func searchCategories(query: String) {
        let filtered = categories.value.filter { (categor) -> Bool in
            categor.name.contains(query)
        }

        filteredCategories.send(filtered)
    }

}
