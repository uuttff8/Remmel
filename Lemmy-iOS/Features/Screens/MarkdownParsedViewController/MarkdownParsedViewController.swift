//
//  MarkdownParsedViewController.swift
//  Lemmy-iOS
//
//  Created by uuttff8 on 02.11.2020.
//  Copyright © 2020 Anton Kuzmin. All rights reserved.
//

import UIKit
import SwiftyMarkdown

class MarkdownParsedViewController: UIViewController {
    
    let lbl: UILabel = {
        let lbl = UILabel()
        lbl.numberOfLines = 0
        
        return lbl
    }()
    
    init(mdString: String) {
        super.init(nibName: nil, bundle: nil)
        view.backgroundColor = .systemBackground
        view.addSubview(lbl)
        let md = SwiftyMarkdown(string: mdString)
        lbl.attributedText = md.attributedString()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        lbl.snp.makeConstraints { (make) in
            make.top.leading.trailing.equalToSuperview().inset(16)
        }
    }
}
