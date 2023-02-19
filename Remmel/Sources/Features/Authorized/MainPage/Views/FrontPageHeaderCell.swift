//
//  FrontPageHeaderCell.swift
//  Lemmy-iOS
//
//  Created by uuttff8 on 9/12/20.
//  Copyright © 2020 Anton Kuzmin. All rights reserved.
//

import UIKit
import RMModels

protocol FrontPageHeaderCellDelegate: AnyObject {
    func contentTypeChanged(to content: LemmyContentType)
}

class FrontPageHeaderView: UIView {
    weak var delegate: FrontPageHeaderCellDelegate?

    let contentTypeSegment: FrontPageSwitcher

    init(contentSelected: LemmyContentType) {
        self.contentTypeSegment = FrontPageSwitcher(
            data: (LemmyContentType.posts.label, LemmyContentType.comments.label),
            selectedIndex: contentSelected.index
        )
        super.init(frame: .zero)

        contentTypeSegment.segmentControl.addTarget(
            self,
            action: #selector(segmentContentTypeChanged(_:)),
            for: .valueChanged
        )

        contentTypeSegment.segmentControl.selectedSegmentIndex = 0

        addSubview(contentTypeSegment)

        contentTypeSegment.snp.makeConstraints { make in
            make.top.bottom.leading.equalToSuperview()
            make.trailing.equalToSuperview()
        }
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    @objc func segmentContentTypeChanged(_ sender: Any) {
        let contentType = LemmyContentType.allCases[contentTypeSegment.segmentControl.selectedSegmentIndex]
        self.delegate?.contentTypeChanged(to: contentType)
    }
}

class FrontPageHeaderCell: UITableViewCell {

    let customView: FrontPageHeaderView

    init(contentSelected: LemmyContentType, postListing: RMModel.Others.ListingType) {
        self.customView = FrontPageHeaderView(contentSelected: contentSelected)
        super.init(style: .default, reuseIdentifier: nil)

        contentView.addSubview(customView)

        customView.snp.makeConstraints { make in
            make.top.leading.trailing.bottom.equalToSuperview()
        }
        contentView.snp.remakeConstraints { make in
            make.height.equalTo(40)
            make.width.equalToSuperview()
        }
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override var intrinsicContentSize: CGSize {
        CGSize(width: UIView.noIntrinsicMetric, height: Constants.frontPageHeight)
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

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func setupView() {
        addSubview(segmentControl)
        translatesAutoresizingMaskIntoConstraints = false

        segmentControl.insertSegment(withTitle: self.data.0, at: 0, animated: false)
        segmentControl.insertSegment(withTitle: self.data.1, at: 1, animated: false)
    }

    override var intrinsicContentSize: CGSize {
        CGSize(width: UIView.noIntrinsicMetric, height: 40)
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        segmentControl.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
}

private enum Constants {
    static let frontPageHeight: CGFloat = 40
}
