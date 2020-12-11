//
//  ProfileScreenUI.swift
//  Lemmy-iOS
//
//  Created by uuttff8 on 07.11.2020.
//  Copyright © 2020 Anton Kuzmin. All rights reserved.
//

import UIKit
import SnapKit

protocol ProfileScreenViewDelegate: AnyObject {
    func profileView(_ profileView: ProfileScreenViewController.View, didReportNewHeaderHeight height: CGFloat)
    func profileView(_ profileView: ProfileScreenViewController.View, didRequestScrollToPage index: Int)
    func numberOfPages(in profileView: ProfileScreenViewController.View) -> Int
}

extension ProfileScreenViewController.View {
    struct Appearance {
        // Status bar + navbar + other offsets
        var headerTopOffset: CGFloat = 0.0
        let segmentedControlHeight: CGFloat = 48.0
        
        let minimalHeaderHeight: CGFloat = 240
    }
}

extension ProfileScreenViewController {
    final class View: UIView {
        let appearance: Appearance
        
        private let tabsTitles: [String]
        
        // Height values reported by header view
        private var calculatedHeaderHeight: CGFloat = 0

        private var currentPageIndex = 0
        
        private lazy var headerView = ProfileScreenHeaderView()
        
        private lazy var segmentedControl: TabSegmentedControlView = {
            let control = TabSegmentedControlView(frame: .zero, items: self.tabsTitles)
            control.delegate = self
            return control
        }()
        
        private let pageControllerView: UIView

        // Dynamic scrolling constraints
        private var topConstraint: Constraint?
        private var headerHeightConstraint: Constraint?

        /// Real height for header
        var headerHeight: CGFloat {
            max(
                0,
                min(self.appearance.minimalHeaderHeight, self.calculatedHeaderHeight) + self.appearance.headerTopOffset
            )
        }
        
        weak var delegate: ProfileScreenViewDelegate?
        
        init(
            frame: CGRect = .zero,
            pageControllerView: UIView,
            scrollDelegate: UIScrollViewDelegate? = nil,
            tabsTitles: [String],
            appearance: Appearance = Appearance()
        ) {
            self.tabsTitles = tabsTitles
            self.pageControllerView = pageControllerView
            self.appearance = appearance
            super.init(frame: frame)
            
            self.setupView()
            self.addSubviews()
            self.makeConstraints()
        }
        
        @available(*, unavailable)
        required init?(coder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }
        
        func configure(viewData: ProfileScreenHeaderView.ViewData) {
            self.headerView.configure(viewData: viewData)
            
            // Update header height
            self.calculatedHeaderHeight = self.headerView.calculateHeight()

            self.delegate?.profileView(
                self,
                didReportNewHeaderHeight: self.headerHeight + self.appearance.segmentedControlHeight
            )
            
            self.headerHeightConstraint?.update(offset: self.headerHeight)
        }
        
        func updateScroll(offset: CGFloat) {
            // default position: offset == 0
            // overscroll (parallax effect): offset < 0
            // normal scrolling: offset > 0

            self.headerHeightConstraint?.update(offset: max(self.headerHeight, self.headerHeight + -offset))

            self.topConstraint?.update(offset: min(0, -offset))
        }
        
        func updateCurrentPageIndex(_ index: Int) {
            self.currentPageIndex = index
            self.segmentedControl.selectTab(index: index)
        }
        
        override func hitTest(_ point: CGPoint, with event: UIEvent?) -> UIView? {
            // Dispatch hits to correct views
            func hitView(_ view: UIView, in point: CGPoint) -> UIView? {
                let convertedPoint = self.convert(point, to: view)
                for subview in view.subviews.reversed() {
                    // Skip subview-receiver if it has isUserInteractionEnabled == false
                    // to pass some hits to scrollview (e.g. swipes in header area)
                    let shouldSubviewInteract = subview.isUserInteractionEnabled
                    if subview.frame.contains(convertedPoint) && shouldSubviewInteract {
                        if subview is UIStackView {
                            return hitView(subview, in: convertedPoint)
                        }
                        return subview
                    }
                }
                return nil
            }

            let convertedPoint = self.convert(point, to: self.headerView)
            if self.headerView.bounds.contains(convertedPoint) {
                // Pass hits to header subviews
                let hittedHeaderSubview = hitView(self.headerView, in: point)
                if let hittedHeaderSubview = hittedHeaderSubview {
                    return hittedHeaderSubview
                }
            }

            return super.hitTest(point, with: event)
        }
    }
}

extension ProfileScreenViewController.View: ProgrammaticallyViewProtocol {
    func setupView() {
        self.clipsToBounds = true
        self.backgroundColor = .systemBackground
    }

    func addSubviews() {
        self.addSubview(self.headerView)
        self.addSubview(self.segmentedControl)
        self.insertSubview(self.pageControllerView, aboveSubview: self.headerView)
    }

    func makeConstraints() {
        self.pageControllerView.snp.makeConstraints { make in
            make.top.bottom.equalToSuperview()
            make.leading.trailing.equalTo(self.safeAreaLayoutGuide)
        }

        self.headerView.snp.makeConstraints { make in
            self.topConstraint = make.top.equalToSuperview().constraint
            make.leading.trailing.equalToSuperview()
            self.headerHeightConstraint = make.height.equalTo(self.headerHeight).constraint
        }

        self.segmentedControl.snp.makeConstraints { make in
            make.top.equalTo(self.headerView.snp.bottom)
            make.leading.trailing.equalTo(self.safeAreaLayoutGuide)
            make.height.equalTo(self.appearance.segmentedControlHeight)
        }
    }
}

extension ProfileScreenViewController.View: TabSegmentedControlViewDelegate {
    func tabSegmentedControlView(_ tabSegmentedControlView: TabSegmentedControlView, didSelectTabWithIndex index: Int) {
        let tabsCount = self.delegate?.numberOfPages(in: self) ?? 0
        guard index >= 0, index < tabsCount else {
            return
        }

        self.delegate?.profileView(self, didRequestScrollToPage: index)
        self.currentPageIndex = index
    }
}
