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
    func feedTypeChanged(to feed: LemmyPostListingType)
}

class FrontPageHeaderView: UIView {
    weak var delegate: FrontPageHeaderCellDelegate?

    let contentTypeSegment: FrontPageSwitcher
    let feedTypeSegment: FrontPageSwitcher

    init(contentSelected: LemmyContentType, postListing: LemmyPostListingType) {
        self.contentTypeSegment = FrontPageSwitcher(
            data: (LemmyContentType.posts.label, LemmyContentType.comments.label),
            selectedIndex: contentSelected.index
        )

        self.feedTypeSegment = FrontPageSwitcher(
            data: (LemmyPostListingType.subscribed.label, LemmyPostListingType.all.label),
            selectedIndex: postListing.index
        )

        super.init(frame: .zero)

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

        contentTypeSegment.segmentControl.selectedSegmentIndex = 0
        feedTypeSegment.segmentControl.selectedSegmentIndex = 0

        self.addSubview(contentTypeSegment)
        self.addSubview(feedTypeSegment)

        contentTypeSegment.snp.makeConstraints { (make) in
            make.top.bottom.leading.equalToSuperview()
            make.trailing.equalToSuperview().dividedBy(2)
        }

        feedTypeSegment.snp.makeConstraints { (make) in
            make.top.bottom.equalToSuperview()
            make.leading.equalTo(contentTypeSegment.snp.trailing)
            make.trailing.equalToSuperview()
        }
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    @objc func segmentContentTypeChanged(_ sender: Any) {
        let contentType = LemmyContentType.allCases[contentTypeSegment.segmentControl.selectedSegmentIndex]
        self.delegate?.contentTypeChanged(to: contentType)
    }

    @objc func segmentFeedTypeChanged(_ sender: Any) {
        let feedType = LemmyPostListingType.allCases[feedTypeSegment.segmentControl.selectedSegmentIndex]
        self.delegate?.feedTypeChanged(to: feedType)
    }
}

class FrontPageHeaderCell: UITableViewCell {

    let customView: FrontPageHeaderView

    init(contentSelected: LemmyContentType, postListing: LemmyPostListingType) {
        self.customView = FrontPageHeaderView(contentSelected: contentSelected,
                                              postListing: postListing)

        super.init(style: .default, reuseIdentifier: nil)

        self.contentView.addSubview(customView)
        self.customView.snp.makeConstraints { (make) in
            make.top.leading.trailing.bottom.equalToSuperview()
        }
        self.contentView.snp.remakeConstraints { (make) in
            make.height.equalTo(40)
            make.width.equalToSuperview()
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
    }

    override var intrinsicContentSize: CGSize {
        CGSize(width: UIView.noIntrinsicMetric, height: 40)
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        segmentControl.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
    }
}
