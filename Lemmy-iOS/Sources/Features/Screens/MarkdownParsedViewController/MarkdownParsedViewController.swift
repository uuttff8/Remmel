//
//  MarkdownParsedViewController.swift
//  Lemmy-iOS
//
//  Created by uuttff8 on 02.11.2020.
//  Copyright © 2020 Anton Kuzmin. All rights reserved.
//

import UIKit
import markymark

final class MarkdownParsedViewController: UIViewController, CatalystDismissProtocol {
    
    private lazy var closeBarButton = UIBarButtonItem(
        barButtonSystemItem: .close,
        target: self,
        action: #selector(dismissVc)
    )
    
    private lazy var mdTextView = MarkDownTextView(
        markDownConfiguration: .attributedString,
        flavor: ContentfulFlavor(),
        styling: .init()
    ).then {
        $0.urlOpener = DefaultURLOpener()
    }

    init(mdString: String) {
        super.init(nibName: nil, bundle: nil)
        
        self.navigationItem.rightBarButtonItem = closeBarButton
        
        mdTextView.text = mdString
        
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
}

extension MarkdownParsedViewController: ProgrammaticallyViewProtocol {
    func setupView() {
        view.backgroundColor = .systemBackground
    }
    
    func addSubviews() {
        view.addSubview(mdTextView)
    }
    
    func makeConstraints() {
        mdTextView.snp.makeConstraints {
            $0.edges.equalTo(self.view.safeAreaLayoutGuide).inset(10)
        }
    }
}

//extension CommentCenterView: URLOpener {
//    func open(url: URL) {
//        if let mention = LemmyUserMention(url: url) {
//            onUserMentionTap?(mention)
//            return
//        }
//
//        if let mention = LemmyCommunityMention(url: url) {
//            onCommunityMentionTap?(mention)
//            return
//        }
//    }
//}


extension MarkdownParsedViewController: StyledNavigationControllerPresentable {
    var navigationBarAppearanceOnFirstPresentation: StyledNavigationController.NavigationBarAppearanceState {
        .pageSheetAppearance()
    }
}
