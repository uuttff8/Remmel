//
//  FrontPageHeaderCell.swift
//  Lemmy-iOS
//
//  Created by uuttff8 on 9/12/20.
//  Copyright © 2020 Anton Kuzmin. All rights reserved.
//

import UIKit

protocol FrontPageHeaderCellDelegate: AnyObject {
    func contentTypeChanged(to content: LemmyContentType)
    func feedTypeChanged(to feed: LemmyFeedType)
}

class FrontPageHeaderCell: UITableViewCell {
    
    weak var delegate: FrontPageHeaderCellDelegate?
    
    let contentTypeSegment: FrontPageSwitcher
    let feedTypeSegment: FrontPageSwitcher
    
    init(contentSelected: LemmyContentType, feedType: LemmyFeedType) {
        self.contentTypeSegment = FrontPageSwitcher(
            data: (LemmyContentType.posts.label, LemmyContentType.comments.label),
            selectedIndex: contentSelected.index
        )
        
        self.feedTypeSegment = FrontPageSwitcher(
            data: (LemmyFeedType.subscribed.label, LemmyFeedType.all.label),
            selectedIndex: feedType.index
        )

        super.init(style: .default, reuseIdentifier: nil)
                
        contentTypeSegment.segmentControl.addTarget(
            self,
            action: #selector(segmentContentTypeChanged(_:)),
            for: .valueChanged
        )
        feedTypeSegment.segmentControl.addTarget(
            self,
            action: #selector(segmentFeedTypeChanged(_:)),
            for: .valueChanged
        )
        
        self.addSubview(contentTypeSegment)
        self.addSubview(feedTypeSegment)
        
        contentTypeSegment.snp.makeConstraints { (make) in
            make.bottom.top.leading.equalToSuperview()
            make.trailing.equalToSuperview().dividedBy(2)
        }
        
        feedTypeSegment.snp.makeConstraints { (make) in
            make.height.equalTo(40)
            make.bottom.top.trailing.equalToSuperview()
            make.leading.equalTo(contentTypeSegment.snp.trailing)
        }
    }
    
    @objc func segmentContentTypeChanged(_ sender: Any) {
        let contentType = LemmyContentType.allCases[contentTypeSegment.segmentControl.selectedSegmentIndex]
        self.delegate?.contentTypeChanged(to: contentType)
    }
    
    @objc func segmentFeedTypeChanged(_ sender: Any) {
        let feedType = LemmyFeedType.allCases[feedTypeSegment.segmentControl.selectedSegmentIndex]
        self.delegate?.feedTypeChanged(to: feedType)
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
