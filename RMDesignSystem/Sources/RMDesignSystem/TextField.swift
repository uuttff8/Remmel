import UIKit

public final class TextField: UIView {
    
    public let textField = PaddingTextField(padding: UIEdgeInsets(top: 0, left: 20, bottom: 0, right: 0))
    
    public var placeholder: String? {
        get { textField.placeholder }
        set { textField.placeholder = newValue }
    }
    
    override init(frame: CGRect = .zero) {
        super.init(frame: frame)
        addSubview(textField)
        textField.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        layer.cornerRadius = 12
        backgroundColor = .white
        textField.placeholder = "123123"
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

public final class PaddingTextField: UITextField {
    
    let padding: UIEdgeInsets
    
    init(padding: UIEdgeInsets) {
        self.padding = padding
        super.init(frame: .zero)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public override func textRect(forBounds bounds: CGRect) -> CGRect {
        bounds.inset(by: padding)
    }
    
    public override func editingRect(forBounds bounds: CGRect) -> CGRect {
        bounds.inset(by: padding)
    }
}
