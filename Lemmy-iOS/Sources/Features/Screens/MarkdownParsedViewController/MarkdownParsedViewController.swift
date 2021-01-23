//
//  MarkdownParsedViewController.swift
//  Lemmy-iOS
//
//  Created by uuttff8 on 02.11.2020.
//  Copyright © 2020 Anton Kuzmin. All rights reserved.
//

import UIKit
import SwiftyMarkdown

final class MarkdownParsedViewController: UIViewController {
    
    let scrollableStackView = ScrollableStackView(orientation: .vertical)
    
    private lazy var closeBarButton = UIBarButtonItem(
        barButtonSystemItem: .close,
        target: self,
        action: #selector(dismissVc)
    )
    
    let lbl: UILabel = {
        let lbl = UILabel()
        lbl.numberOfLines = 0
        
        return lbl
    }()
    
    init(mdString: String) {
        super.init(nibName: nil, bundle: nil)
        
        self.navigationItem.rightBarButtonItem = closeBarButton
        let md = SwiftyMarkdown(string: mdString)
        lbl.attributedText = md.attributedString()
        
        setupView()
        addSubviews()
        makeConstraints()
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Description"
    }
    
    @objc func dismissVc() {
        self.dismiss(animated: true)
    }
}

extension MarkdownParsedViewController: ProgrammaticallyViewProtocol {
    func setupView() {
        view.backgroundColor = .systemBackground
    }
    
    func addSubviews() {
        view.addSubview(scrollableStackView)
        scrollableStackView.addArrangedView(lbl)
        scrollableStackView.contentInsets = .init(top: 16, left: 0, bottom: 0, right: 0)
        scrollableStackView.showsHorizontalScrollIndicator = false
    }
    
    func makeConstraints() {
        scrollableStackView.snp.makeConstraints {
            $0.edges.equalTo(self.view.safeAreaLayoutGuide).inset(10)
        }
    }
}

extension MarkdownParsedViewController: StyledNavigationControllerPresentable {
    var navigationBarAppearanceOnFirstPresentation: StyledNavigationController.NavigationBarAppearanceState {
        .pageSheetAppearance()
    }
}
