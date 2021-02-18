//
//  MarkdownParsedViewController.swift
//  Lemmy-iOS
//
//  Created by uuttff8 on 02.11.2020.
//  Copyright © 2020 Anton Kuzmin. All rights reserved.
//

import UIKit
import MarkdownUI

final class MarkdownParsedViewController: UIViewController, CatalystDismissProtocol {
    
    private lazy var closeBarButton = UIBarButtonItem(
        barButtonSystemItem: .close,
        target: self,
        action: #selector(dismissVc)
    )
    
    private lazy var lbl: LabeledTextView = {
        let lbl = LabeledTextView()
        
        lbl.linkTextAttributes = [.foregroundColor: UIColor.lemmyBlue,
                                              .underlineStyle: 0,
                                              .underlineColor: UIColor.clear]
        
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
        title = "create-content-community-description".localized
    }
    
    override func pressesBegan(_ presses: Set<UIPress>, with event: UIPressesEvent?) {
        self.dismissWithExitButton(presses: presses)
    }
    
    @objc func dismissVc() {
        self.dismiss(animated: true)
    }
    
    private func attributtedMarkdown(_ subtitle: String) -> NSAttributedString {
        let attr = NSAttributedString(document: Document(subtitle), style: .init(font: .system(size: 16)))
        return attr
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

extension MarkdownParsedViewController: UITextViewDelegate {
    func textView(
        _ textView: UITextView,
        shouldInteractWith URL: URL,
        in characterRange: NSRange,
        interaction: UITextItemInteraction
    ) -> Bool {
        let link = URL
        
        // TODO uncomment and go to these
        if let mention = LemmyUserMention(url: link) {
//            onUserMentionTap?(mention)
            return false
        }
        
        if let mention = LemmyCommunityMention(url: link) {
//            onCommunityMentionTap?(mention)
            return false
        }
        
        return true
    }
}

extension MarkdownParsedViewController: StyledNavigationControllerPresentable {
    var navigationBarAppearanceOnFirstPresentation: StyledNavigationController.NavigationBarAppearanceState {
        .pageSheetAppearance()
    }
}
