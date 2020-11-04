//
//  CommunityScreen.swift
//  Lemmy-iOS
//
//  Created by uuttff8 on 01.11.2020.
//  Copyright © 2020 Anton Kuzmin. All rights reserved.
//

import UIKit

class CommunityScreenViewController: UIViewController {
    
    let model = CommunityScreenModel()
    lazy var customView = CommunityScreenUI(model: self.model)
    
    private init() {
        super.init(nibName: nil, bundle: nil)
    }
    
    convenience init(community: LemmyApiStructs.CommunityView) {
        self.init()
        
        model.communitySubject.send(community)
    }
    
    convenience init(fromId: Int) {
        self.init()
        
        model.loadCommunity(id: fromId)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func loadView() {
        self.view = customView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        model.communitySubject
            .receive(on: RunLoop.main)
            .compactMap { $0 }
            .sink(receiveValue: updateUIOnData(community:))
            .store(in: &customView.cancellable)
        
    }
    
    func updateUIOnData(community: LemmyApiStructs.CommunityView) {
        self.title = community.name
        
        customView.communityHeaderView.descriptionReadMoreButton.addAction(UIAction(handler: { (_) in
            if let desc = community.description {
                
                let vc = MarkdownParsedViewController(mdString: desc)
                self.present(vc, animated: true)
            }
        }), for: .touchUpInside)
        
        customView.contentTypeView.contentTypePicker.addTap {
            let vc = self.customView.contentTypeView.contentTypePicker.configuredAlert
            self.present(vc, animated: true, completion: nil)
        }
    }
}
