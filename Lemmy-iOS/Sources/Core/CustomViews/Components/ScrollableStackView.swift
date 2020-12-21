//
//  ScrollableStackView.swift
//  Lemmy-iOS
//
//  Created by uuttff8 on 10.11.2020.
//  Copyright © 2020 Anton Kuzmin. All rights reserved.
//

import UIKit

protocol ScrollableStackViewDelegate: AnyObject {
    func scrollableStackViewRefreshControlDidRefresh(_ scrollableStackView: ScrollableStackView)
}

final class ScrollableStackView: UIView {
    private let orientation: Orientation
    weak var delegate: ScrollableStackViewDelegate?

    private lazy var stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = self.orientation.stackViewOrientation
        return stackView
    }()

    private lazy var scrollView = UIScrollView()

    // MARK: - Refresh control

    var isRefreshControlEnabled: Bool = false {
        didSet {
            guard oldValue != self.isRefreshControlEnabled else {
                return
            }

            let refreshControl = self.isRefreshControlEnabled ? UIRefreshControl() : nil
            if let refreshControl = refreshControl {
                refreshControl.addTarget(
                    self,
                    action: #selector(self.onRefreshControlValueChanged),
                    for: .valueChanged
                )
            }

            self.scrollView.refreshControl = refreshControl
        }
    }

    private var refreshControl: UIRefreshControl? {
        self.scrollView.subviews.first(where: { $0 is UIRefreshControl }) as? UIRefreshControl
    }

    // MARK: - Blocks

    var arrangedSubviews: [UIView] {
        self.stackView.arrangedSubviews
    }

    // MARK: - Proxy properties

    var showsHorizontalScrollIndicator: Bool {
        get {
             self.scrollView.showsHorizontalScrollIndicator
        }
        set {
            self.scrollView.showsHorizontalScrollIndicator = newValue
        }
    }

    var showsVerticalScrollIndicator: Bool {
        get {
             self.scrollView.showsVerticalScrollIndicator
        }
        set {
            self.scrollView.showsVerticalScrollIndicator = newValue
        }
    }

    var spacing: CGFloat {
        get {
             self.stackView.spacing
        }
        set {
            self.stackView.spacing = newValue
        }
    }

    var contentInsetAdjustmentBehavior: UIScrollView.ContentInsetAdjustmentBehavior {
        get {
             self.scrollView.contentInsetAdjustmentBehavior
        }
        set {
            self.scrollView.contentInsetAdjustmentBehavior = newValue
        }
    }

    var scrollDelegate: UIScrollViewDelegate? {
        get {
             self.scrollView.delegate
        }
        set {
            self.scrollView.delegate = newValue
        }
    }

    var contentInsets: UIEdgeInsets {
        get {
             self.scrollView.contentInset
        }
        set {
            self.scrollView.contentInset = newValue
        }
    }

    var contentOffset: CGPoint {
        get {
             self.scrollView.contentOffset
        }
        set {
            self.scrollView.contentOffset = newValue
        }
    }

    var scrollIndicatorInsets: UIEdgeInsets {
        get {
             self.scrollView.verticalScrollIndicatorInsets
        }
        set {
            self.scrollView.scrollIndicatorInsets = newValue
        }
    }

    @available(iOS 11.1, *)
    var verticalScrollIndicatorInsets: UIEdgeInsets {
        get {
            self.scrollView.verticalScrollIndicatorInsets
        }
        set {
            self.scrollView.verticalScrollIndicatorInsets = newValue
        }
    }

    @available(iOS 11.1, *)
    var horizontalScrollIndicatorInsets: UIEdgeInsets {
        get {
            self.scrollView.horizontalScrollIndicatorInsets
        }
        set {
            self.scrollView.horizontalScrollIndicatorInsets = newValue
        }
    }

    @available(iOS 13.0, *)
    var automaticallyAdjustsScrollIndicatorInsets: Bool {
        get {
            self.scrollView.automaticallyAdjustsScrollIndicatorInsets
        }
        set {
            self.scrollView.automaticallyAdjustsScrollIndicatorInsets = newValue
        }
    }

    var shouldBounce: Bool {
        get {
             self.scrollView.bounces
        }
        set {
            self.scrollView.bounces = newValue
        }
    }

    var isPagingEnabled: Bool {
        get {
             self.scrollView.isPagingEnabled
        }
        set {
            self.scrollView.isPagingEnabled = newValue
        }
    }

    var isScrollEnabled: Bool {
        get {
             self.scrollView.isScrollEnabled
        }
        set {
            self.scrollView.isScrollEnabled = newValue
        }
    }

    var contentSize: CGSize {
        get {
             self.scrollView.contentSize
        }
        set {
            self.scrollView.contentSize = newValue
        }
    }

    // MARK: - Inits

    init(frame: CGRect = .zero, orientation: Orientation) {
        self.orientation = orientation
        super.init(frame: frame)

        self.setupView()
        self.addSubviews()
        self.makeConstraints()
    }

    @available(*, unavailable)
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: Public interface

    func addArrangedView(_ view: UIView) {
        self.stackView.addArrangedSubview(view)
    }

    func removeArrangedView(_ view: UIView) {
        for subview in self.stackView.subviews where subview == view {
            self.stackView.removeArrangedSubview(subview)
            subview.removeFromSuperview()
        }
    }

    func insertArrangedView(_ view: UIView, at index: Int) {
        self.stackView.insertArrangedSubview(view, at: index)
    }

    func removeAllArrangedViews() {
        for subview in self.stackView.subviews {
            self.removeArrangedView(subview)
        }
    }

    func startRefreshing() {
        self.refreshControl?.beginRefreshing()
    }

    func endRefreshing() {
        self.refreshControl?.endRefreshing()
    }

    func scrollTo(arrangedViewIndex: Int) {
        guard let targetFrame = self.arrangedSubviews[safe: arrangedViewIndex]?.frame else {
            return
        }

        self.scrollView.scrollRectToVisible(targetFrame, animated: true)
    }

    // MARK: - Private methods

    @objc
    private func onRefreshControlValueChanged() {
        self.delegate?.scrollableStackViewRefreshControlDidRefresh(self)
    }

    enum Orientation {
        case vertical
        case horizontal

        var stackViewOrientation: NSLayoutConstraint.Axis {
            switch self {
            case .vertical:
                return NSLayoutConstraint.Axis.vertical
            case .horizontal:
                return NSLayoutConstraint.Axis.horizontal
            }
        }
    }
}

extension ScrollableStackView: ProgrammaticallyViewProtocol {
    func setupView() {
        self.stackView.clipsToBounds = false
        self.scrollView.clipsToBounds = false

        // For pull-to-refresh when contentSize is too small for scrolling
        if self.orientation == .horizontal {
            self.scrollView.alwaysBounceHorizontal = true
        } else {
            self.scrollView.alwaysBounceVertical = true
        }
        self.scrollView.bounces = true
    }

    func addSubviews() {
        self.addSubview(self.scrollView)
        self.scrollView.addSubview(self.stackView)
    }

    func makeConstraints() {
        self.scrollView.translatesAutoresizingMaskIntoConstraints = false
        self.scrollView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }

        self.stackView.translatesAutoresizingMaskIntoConstraints = false
        self.stackView.snp.makeConstraints { make in
            make.edges.equalToSuperview()

            if case .vertical = self.orientation {
                make.width.equalTo(self.scrollView.snp.width)
            } else {
                make.height.equalTo(self.scrollView.snp.height)
            }
        }
    }
}

@IBDesignable
public class ScrollStackView: UIView {
    
    fileprivate var didSetupConstraints = false
    @IBInspectable open var spacing: CGFloat = 8
    open var durationForAnimations:TimeInterval = 1.45
    
    public lazy var scrollView: UIScrollView = {
        let instance = UIScrollView(frame: CGRect.zero)
        instance.translatesAutoresizingMaskIntoConstraints = false
        instance.layoutMargins = .zero
        return instance
    }()

    public lazy var stackView: UIStackView = {
        let instance = UIStackView(frame: CGRect.zero)
        instance.translatesAutoresizingMaskIntoConstraints = false
        instance.axis = .vertical
        instance.spacing = self.spacing
        instance.distribution = .equalSpacing
        return instance
    }()

    //MARK: View life cycle
    override public func didMoveToSuperview() {
        super.didMoveToSuperview()
        
        setupUI()
    }
    
    //MARK: UI
    func setupUI() {
        translatesAutoresizingMaskIntoConstraints = false
        clipsToBounds = true

        addSubview(scrollView)
        scrollView.addSubview(stackView)

        setNeedsUpdateConstraints() // Bootstrap auto layout
    }
    
    // Scrolls to item at index
    public func scrollToItem(index: Int) {
        if stackView.arrangedSubviews.count > 0 {
            let view = stackView.arrangedSubviews[index]
            
            UIView.animate(withDuration: durationForAnimations, animations: {
                self.scrollView.setContentOffset(CGPoint(x: 0, y:view.frame.origin.y), animated: true)
            })
        }
    }
    
    // Used to scroll till the end of scrollview
    public func scrollToBottom() {
        if stackView.arrangedSubviews.count > 0 {
            UIView.animate(withDuration: durationForAnimations, animations: {
                self.scrollView.scrollToBottom(true)
            })
        }
    }
    
    // Scrolls to top of scrollable area
    public func scrollToTop() {
        if stackView.arrangedSubviews.count > 0 {
            UIView.animate(withDuration: durationForAnimations, animations: {
                self.scrollView.setContentOffset(CGPoint(x: 0, y:0), animated: true)
            })
        }
    }
    
    override public func updateConstraints() {
        super.updateConstraints()
        
        if !didSetupConstraints {
            scrollView.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
            scrollView.leadingAnchor.constraint(equalTo: self.leadingAnchor).isActive = true
            scrollView.trailingAnchor.constraint(equalTo: self.trailingAnchor).isActive = true
            scrollView.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true

            stackView.topAnchor.constraint(equalTo: scrollView.topAnchor).isActive = true
            stackView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor).isActive = true
            stackView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor).isActive = true
            stackView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor).isActive = true
            
            // Set the width of the stack view to the width of the scroll view for vertical scrolling
            stackView.widthAnchor.constraint(equalTo: scrollView.widthAnchor).isActive = true
            
            didSetupConstraints = true
        }
    }
}

// Used to scroll till the end of scrollview
extension UIScrollView {
    func scrollToBottom(_ animated: Bool) {
        if self.contentSize.height < self.bounds.size.height { return }
        let bottomOffset = CGPoint(x: 0, y: self.contentSize.height - self.bounds.size.height)
        self.setContentOffset(bottomOffset, animated: animated)
    }
}
