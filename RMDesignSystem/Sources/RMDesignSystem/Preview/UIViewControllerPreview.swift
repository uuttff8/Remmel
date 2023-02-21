//
//  UIViewControllerPreview.swift
//  
//
//  Created by uuttff8 on 21/02/2023.
//

import UIKit
import SwiftUI

struct UIViewControllerPreview<ViewController: UIViewController>: UIViewControllerRepresentable {
    let viewController: ViewController
    
    init(_ builder: @escaping () -> ViewController) {
        viewController = builder()
    }
    
    func makeUIViewController(context: Context) -> ViewController { viewController }
    
    func updateUIViewController(_ uiViewController: ViewController, context: Context) {}
}

class PreviewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let textField = TextField()
        view.addSubview(textField)
        textField.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide).inset(20)
            make.leading.trailing.equalToSuperview().inset(20)
            make.height.equalTo(44)
        }
        
        view.backgroundColor = .systemGray5
    }
}

struct ViewControllerPreviews: PreviewProvider {
    static var previews: some View {
        UIViewControllerPreview {
            return PreviewController()
        }
        .previewDevice("iPhone SE (2nd generation)")
    }
}
