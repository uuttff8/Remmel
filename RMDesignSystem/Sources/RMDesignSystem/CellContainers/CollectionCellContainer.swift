//
//  CollectionCellContainer.swift
//  
//
//  Created by uuttff8 on 21/02/2023.
//

import UIKit
import SnapKit

class CollectionCellContainer<View: ReusableView>: UICollectionViewCell {
    private(set) var containedView: View = View(frame: .zero)
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setup() {
        contentView.addSubview(containedView)
        snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        containedView.reuse()
    }
}
