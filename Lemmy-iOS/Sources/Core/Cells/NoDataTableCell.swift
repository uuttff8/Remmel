//
//  NoDataTableCell.swift
//  Lemmy-iOS
//
//  Created by uuttff8 on 16.12.2020.
//  Copyright © 2020 Anton Kuzmin. All rights reserved.
//

import UIKit

class NoDataTableCell: UITableViewCell {
    enum Config {
        case error(String)
        case activityIndicator
    }
    
    private var config: Config?
    
    let errorLabel = UILabel()
    
    let activityIndicatorView = UIActivityIndicatorView().then {
        $0.hidesWhenStopped = true
        $0.style = .large
    }
    
    func bind(with config: Config) {
        self.config = config
        
        addSubviews()
        makeConstraints()
    }
}

extension NoDataTableCell: ProgrammaticallyViewProtocol {
    func addSubviews() {
        guard let config = config else {
            return
        }

        contentView.addSubview(activityIndicatorView)
    }
    
    func makeConstraints() {
        guard let config = config else {
            return
        }
        
        switch config {
        case .error:
            errorLabel.snp.makeConstraints {
                $0.center.equalToSuperview()
            }
            
        case .activityIndicator:
            activityIndicatorView.snp.makeConstraints {
                $0.center.equalToSuperview()
            }
            
        }
    }
}
