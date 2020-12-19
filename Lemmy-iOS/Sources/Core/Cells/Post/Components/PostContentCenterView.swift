//
//  PostContentCenterView.swift
//  Lemmy-iOS
//
//  Created by uuttff8 on 01.12.2020.
//  Copyright © 2020 Anton Kuzmin. All rights reserved.
//

import UIKit
import SwiftyMarkdown
import Nantes

// MARK: - PostContentCenterView: UIView
class PostContentCenterView: UIView {
    
    // MARK: - Data
    struct ViewData {
        let imageUrl: String?
        let title: String
        let subtitle: String?
    }
    
    // MARK: - Properties
    var onLinkTap: ((URL) -> Void)?
    var onMentionTap: ((LemmyMention) -> Void)?
    
    private let imageSize = CGSize(width: 110, height: 60)
    
    private let titleLabel = UILabel().then {
        $0.font = UIFont.systemFont(ofSize: 20, weight: .semibold)
        $0.numberOfLines = 3
    }
    
    private lazy var subtitleLabel = NantesLabel().then {
        $0.font = UIFont.systemFont(ofSize: 13, weight: .regular)
        $0.delegate = self
    }
    
    private let thumbailImageView = UIImageView().then {
        $0.layer.cornerRadius = 5
        $0.layer.masksToBounds = false
        $0.clipsToBounds = true
        $0.contentMode = .scaleAspectFill
    }
    
    private let mainStackView = UIStackView().then {
        $0.axis = .vertical
        $0.spacing = 10
    }
    
    private let titleImageStackView = UIStackView().then {
        $0.alignment = .top
        $0.spacing = 8
    }
    
    // MARK: - Init
    override init(frame: CGRect) {
        super.init(frame: .zero)
        
        setupView()
        addSubviews()
        makeConstraints()
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Public
    func bind(config: PostContentType, with data: PostContentCenterView.ViewData) {
        titleLabel.text = data.title
        
        if let subtitle = data.subtitle {
            let md = SwiftyMarkdown(string: subtitle)
            
            // if not case .preview
            if case .preview = config {
                
            } else {
                md.link.color = .systemBlue
            }
            
            subtitleLabel.attributedText = md.attributedString()
        }
        
        switch config {
        case .fullPost:
            subtitleLabel.numberOfLines = 0
            
            if let subtitle = data.subtitle {
                let md = SwiftyMarkdown(string: subtitle)
                md.link.color = .systemBlue
                md.setFontSizeForAllStyles(with: 13)
                subtitleLabel.attributedText = md.attributedString()
            }
        case .insideComminity, .preview:
            
            subtitleLabel.numberOfLines = 6
            
            if let subtitle = data.subtitle?.removeNewLines() {
                let md = SwiftyMarkdown(string: subtitle)
                md.setFontSizeForAllStyles(with: 13)
                subtitleLabel.attributedText = md.attributedString()
            }
        }
        
        thumbailImageView.loadImage(urlString: data.imageUrl)
    }
    
    func prepareForReuse() {
        titleLabel.text = nil
        subtitleLabel.text = nil
        thumbailImageView.image = nil
        thumbailImageView.isHidden = false
    }
        
    // MARK: - Overrided
    override var intrinsicContentSize: CGSize {
        CGSize(width: UIScreen.main.bounds.width, height: UIView.noIntrinsicMetric)
    }
}

extension PostContentCenterView: NantesLabelDelegate {
    func attributedLabel(_ label: NantesLabel, didSelectLink link: URL) {
        if let mention = LemmyMention(url: link) {
            onMentionTap?(mention)
            return
        }
        
        onLinkTap?(link)
    }
}

extension PostContentCenterView: ProgrammaticallyViewProtocol {
    func addSubviews() {
        self.addSubview(mainStackView)
        
        titleImageStackView.addStackViewItems(
            .view(titleLabel),
            .view(thumbailImageView)
        )
        
        mainStackView.addStackViewItems(
            .view(titleImageStackView),
            .view(subtitleLabel)
        )
    }
    
    func makeConstraints() {
        thumbailImageView.snp.makeConstraints { (make) in
            make.size.equalTo(imageSize)
        }
        
        mainStackView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
    }
}
