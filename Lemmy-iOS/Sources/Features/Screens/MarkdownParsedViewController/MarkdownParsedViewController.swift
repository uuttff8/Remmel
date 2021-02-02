//
//  MarkdownParsedViewController.swift
//  Lemmy-iOS
//
//  Created by uuttff8 on 02.11.2020.
//  Copyright © 2020 Anton Kuzmin. All rights reserved.
//

import UIKit
import CocoaMarkdown

final class MarkdownParsedViewController: UIViewController {
    
    let scrollableStackView = ScrollableStackView(orientation: .vertical)
    
    private lazy var closeBarButton = UIBarButtonItem(
        barButtonSystemItem: .close,
        target: self,
        action: #selector(dismissVc)
    )
    
    let lbl: SimpleLabeledTextView = {
        let lbl = SimpleLabeledTextView()
        lbl
        
        return lbl
    }()
    
    init(mdString: String) {
        super.init(nibName: nil, bundle: nil)
        
        self.navigationItem.rightBarButtonItem = closeBarButton
        let docMd = CMDocument(string: mdString, options: .sourcepos)
        let renderMd = CMAttributedStringRenderer(document: docMd, attributes: CMTextAttributes())
        lbl.attributedText = renderMd?.render()
        
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
