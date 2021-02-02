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
    
    private lazy var closeBarButton = UIBarButtonItem(
        barButtonSystemItem: .close,
        target: self,
        action: #selector(dismissVc)
    )
    
    let lbl: LabeledTextView = {
        let lbl = LabeledTextView()
        lbl.isScrollEnabled = true
        return lbl
    }()
    
    init(mdString: String) {
        super.init(nibName: nil, bundle: nil)
        
        self.navigationItem.rightBarButtonItem = closeBarButton
        
        lbl.attributedText = attributtedMarkdown(mdString)
        
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
    
    private func attributtedMarkdown(_ subtitle: String) -> NSAttributedString {
        let docMd = CMDocument(string: subtitle, options: .sourcepos)
        let renderMd = CMAttributedStringRenderer(document: docMd, attributes: CMTextAttributes())
        
        let attributes = NSMutableAttributedString(attributedString: renderMd.require().render())
        attributes.addAttributes([.foregroundColor: UIColor.lemmyLabel],
                                 range: NSRange(location: 0, length: attributes.mutableString.length))
        return attributes
    }

}

extension MarkdownParsedViewController: ProgrammaticallyViewProtocol {
    func setupView() {
        view.backgroundColor = .systemBackground
    }
    
    func addSubviews() {
        view.addSubview(lbl)
    }
    
    func makeConstraints() {
        lbl.snp.makeConstraints {
            $0.edges.equalTo(self.view.safeAreaLayoutGuide).inset(10)
        }
    }
}

extension MarkdownParsedViewController: StyledNavigationControllerPresentable {
    var navigationBarAppearanceOnFirstPresentation: StyledNavigationController.NavigationBarAppearanceState {
        .pageSheetAppearance()
    }
}
