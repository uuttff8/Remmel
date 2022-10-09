//
//  MarkdownParsedViewController.swift
//  Lemmy-iOS
//
//  Created by uuttff8 on 02.11.2020.
//  Copyright © 2020 Anton Kuzmin. All rights reserved.
//

import UIKit
import markymark

final class MarkdownParsedViewController: UIViewController, CatalystDismissable {
    
    // MARK: - UI Properties
    
    private lazy var closeBarButton = UIBarButtonItem(
        barButtonSystemItem: .close,
        target: self,
        action: #selector(dismissVc)
    )
    
    private lazy var mdTextView = {
        $0.urlOpener = DefaultURLOpener()
        return $0
    }(MarkDownTextView(
        markDownConfiguration: .attributedString,
        flavor: ContentfulFlavor(),
        styling: .init()
    ))

    // MARK: - Init
    
    init(mdString: String) {
        super.init(nibName: nil, bundle: nil)
        
        navigationItem.rightBarButtonItem = closeBarButton
        mdTextView.text = mdString
        
        setupView()
        addSubviews()
        makeConstraints()
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Overrides
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "create-content-community-description".localized
    }
    
    override func pressesBegan(_ presses: Set<UIPress>, with event: UIPressesEvent?) {
        dismissWithExitButton(presses: presses)
    }
    
    // MARK: - @objc actions
    
    @objc func dismissVc() {
        dismiss(animated: true)
    }
}

// MARK: - ProgrammaticallyViewProtocol

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

// MARK: - StyledNavigationControllerPresentable

extension MarkdownParsedViewController: StyledNavigationControllerPresentable {
    var navigationBarAppearanceOnFirstPresentation: StyledNavigationController.NavigationBarAppearanceState {
        .pageSheetAppearance()
    }
}
