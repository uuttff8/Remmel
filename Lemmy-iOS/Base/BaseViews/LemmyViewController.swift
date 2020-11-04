//
//  LemmyViewController.swift
//  Lemmy-iOS
//
//  Created by uuttff8 on 04.11.2020.
//  Copyright © 2020 Anton Kuzmin. All rights reserved.
//

import UIKit

class LemmyViewController<V: LemmyView>: UIViewController {
    
    var customView: V {
        self.view as! V
    }
    
    override func loadView() {
        self.view = V()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        customView.presentOnVc = { toPresentVc in
            self.present(toPresentVc, animated: true)
        }
        
        customView.dismissOnVc = {
            self.dismiss(animated: true)
        }
    }
}
