//
//  WriteCommentViewController.swift
//  Lemmy-iOS
//
//  Created by uuttff8 on 09.12.2020.
//  Copyright © 2020 Anton Kuzmin. All rights reserved.
//

import UIKit

protocol WriteCommentViewControllerProtocol: AnyObject {
    func displayWriteCommentForm(viewModel: WriteComment.FormLoad.ViewModel)
}

class WriteCommentViewController: UIViewController {
    
    lazy var writeCommentView = self.view as! WriteCommentView
    
    enum TableForm: String {
        case headerCell
        case textFieldComment
    }
    
    private let viewModel: WriteCommentViewModelProtocol
    
    init(viewModel: WriteCommentViewModelProtocol) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func loadView() {
        let view = WriteCommentView()
        self.view = view
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
}

extension WriteCommentViewController: WriteCommentViewControllerProtocol {
    func displayWriteCommentForm(viewModel: WriteComment.FormLoad.ViewModel) {
        let headerCell = SettingsTableSectionViewModel.Cell(
            uniqueIdentifier: TableForm.headerCell.rawValue,
            type: .rightDetail(
                options: .init(title: .init(text: viewModel.parrentCommentText ?? ""),
                               detailType: .label(text: nil),
                               accessoryType: .none
                )
            )
        )
        
        let textFieldCell = SettingsTableSectionViewModel.Cell(
            uniqueIdentifier: TableForm.textFieldComment.rawValue,
            type: .largeInput(
                options: .init(
                    valueText: nil,
                    placeholderText: nil,
                    maxLength: nil
                )
            )
        )
        
        let sections: [SettingsTableSectionViewModel] = [
            .init(
                header: nil,
                cells: [headerCell],
                footer: nil
            ),
            .init(
                header: nil,
                cells: [textFieldCell],
                footer: nil
            )
        ]
        
        let viewModel = SettingsTableViewModel(sections: sections)
        self.writeCommentView.configure(viewModel: viewModel)
        
    }
}
