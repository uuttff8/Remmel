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
    let categories: PassthroughSubject<[LemmyApiStructs.CategoryView], Never> = PassthroughSubject()
    
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
}
