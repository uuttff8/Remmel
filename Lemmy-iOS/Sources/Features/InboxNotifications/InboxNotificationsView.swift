//
//  InboxNotificationsView.swift
//  Lemmy-iOS
//
//  Created by uuttff8 on 06.01.2021.
//  Copyright © 2021 Anton Kuzmin. All rights reserved.
//

import UIKit

protocol InboxNotificationsViewDelegate: AnyObject {
    func inboxNotifView(_ view: InboxNotificationsView, didReportNewHeaderHeight height: CGFloat)
    func inboxNotifView(_ view: InboxNotificationsView, didRequestScrollToPage index: Int)
    func numberOfPages(in profileView: InboxNotificationsView) -> Int
}

extension InboxNotificationsView {
    struct Appearance {
        let segmentedControlHeight = 48.0
    }
}

final class InboxNotificationsView: UIView {
    
    let appearance: Appearance
    
    weak var delegate: InboxNotificationsViewDelegate?
    
    private let tabsTitles: [String]
    private var currentPageIndex = 0
    
    private lazy var segmentedControl: TabSegmentedControlView = {
        let control = TabSegmentedControlView(frame: .zero, items: self.tabsTitles)
        control.delegate = self
        return control
    }()
    
    private let pageControllerView: UIView
    
    init(
        frame: CGRect = .zero,
        pageControllerView: UIView,
        tabsTitles: [String],
        appearance: Appearance = Appearance()
    ) {
        self.appearance = appearance
        self.tabsTitles = tabsTitles
        self.pageControllerView = pageControllerView
        super.init(frame: frame)
        
        setupView()
        addSubviews()
        makeConstraints()
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func updateCurrentPageIndex(_ index: Int) {
        self.currentPageIndex = index
        self.segmentedControl.selectTab(index: index)
    }
}

extension InboxNotificationsView: ProgrammaticallyViewProtocol {
    func setupView() {
        self.clipsToBounds = true
        self.backgroundColor = .systemBackground
    }

    func addSubviews() {
        self.addSubview(self.segmentedControl)
        self.insertSubview(self.pageControllerView, aboveSubview: self.segmentedControl)
    }

    func makeConstraints() {
        self.pageControllerView.snp.makeConstraints { make in
            make.top.bottom.equalToSuperview()
            make.leading.trailing.equalTo(self.safeAreaLayoutGuide)
        }

        self.segmentedControl.snp.makeConstraints { make in
            make.top.equalTo(self.pageControllerView.snp.bottom)
            make.leading.trailing.equalTo(self.safeAreaLayoutGuide)
            make.height.equalTo(self.appearance.segmentedControlHeight)
        }
    }
}

extension InboxNotificationsView: TabSegmentedControlViewDelegate {
    func tabSegmentedControlView(_ tabSegmentedControlView: TabSegmentedControlView, didSelectTabWithIndex index: Int) {
        let tabsCount = self.delegate?.numberOfPages(in: self) ?? 0
        guard index >= 0, index < tabsCount else {
            return
        }

        self.delegate?.inboxNotifView(self, didRequestScrollToPage: index)
        self.currentPageIndex = index
    }
}
