//
//  FrontPageHeaderCell.swift
//  Lemmy-iOS
//
//  Created by uuttff8 on 9/12/20.
//  Copyright © 2020 Anton Kuzmin. All rights reserved.
//

import UIKit

class FrontPageHeaderCell: UITableViewCell {
    
    init() {
        super.init(style: .default, reuseIdentifier: nil)
        
        self.contentView.snp.remakeConstraints { (make) in
            make.height.equalTo(40)
        }
        
        let frontPagePostsType = FrontPageSwitcher(data: ("Posts", "Comments"), selectedIndex: 0)
        self.addSubview(frontPagePostsType)
        frontPagePostsType.snp.makeConstraints { (make) in
            make.bottom.top.leading.equalToSuperview()
            make.trailing.equalToSuperview().dividedBy(2)
        }
        
        let frontPageFeed = FrontPageSwitcher(data: ("Subscribed", "All"), selectedIndex: 1)
        self.addSubview(frontPageFeed)
        frontPageFeed.snp.makeConstraints { (make) in
            make.bottom.top.trailing.equalToSuperview()
            make.leading.equalTo(frontPagePostsType.snp.trailing)
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        
    }
    
    override var intrinsicContentSize: CGSize {
        CGSize(width: UIView.noIntrinsicMetric, height: 40)
    }
}

class FrontPageSwitcher: UIView {
    private var data: (String, String)!
    
    let segmentControl: UISegmentedControl = {
        let seg = UISegmentedControl()
        seg.translatesAutoresizingMaskIntoConstraints = false
        return seg
    }()
    
    init(data: (String, String), selectedIndex: Int) {
        self.data = data
        super.init(frame: .zero)
        setupView()
        segmentControl.selectedSegmentIndex = selectedIndex
    }
    
    override init(frame: CGRect) {
        super.init(frame: .zero)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    func setupView() {
        self.addSubview(segmentControl)
        translatesAutoresizingMaskIntoConstraints = false
        
        segmentControl.insertSegment(withTitle: self.data.0, at: 0, animated: false)
        segmentControl.insertSegment(withTitle: self.data.1, at: 1, animated: false)
                
        segmentControl.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
    }
    
    override var intrinsicContentSize: CGSize {
        CGSize(width: UIView.noIntrinsicMetric, height: 40)
    }
}
