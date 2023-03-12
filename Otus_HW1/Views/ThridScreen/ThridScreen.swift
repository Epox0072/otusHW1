//
//  ThridScreen.swift
//  Otus_HW1
//
//  Created by Станислав Гапонов on 04.03.2023.
//

import SwiftUI
import UIKit

struct ThridScreen: View {
    
    @State var isModal: Bool = false
    
    var body: some View {
        Button {
            isModal.toggle()
        } label: {
            Text("Open modal view")
        }
        .buttonStyle(.borderless)
        .sheet(isPresented: $isModal) {
            ModalView()
        }
    }
}
/*
struct ModalView: View {
    
    @Environment(\.presentationMode) var presentayionMode
    
    var body: some View {
        VStack {
            Text("⚙️")
                .font(.system(size: 256))
            Button {
                presentayionMode.wrappedValue.dismiss()
            } label: {
                Text("Close")
            }
            .buttonStyle(.borderless)
        }
    }
    
}
*/
struct ThridScreen_Previews: PreviewProvider {
    static var previews: some View {
        ThridScreen()
    }
}

struct ModalView: UIViewRepresentable {
    
    @Environment(\.presentationMode) var presentayionMode
    
    func makeUIView(context: Context) -> UIView {
        ModalViewUIKit(text: "⚙️") {
            presentayionMode.wrappedValue.dismiss()
        }
    }
    
    func updateUIView(_ uiView: UIView, context: Context) {}
    
    
}

class ModalViewUIKit: UIView {
    
    private let text: String
    
    private let close: () -> Void
    
    lazy var label: UILabel = {
        let v = UILabel()
        v.translatesAutoresizingMaskIntoConstraints = false
        v.font = UIFont.systemFont(ofSize: 256)
        v.textAlignment = .center
        return v
    }()
    
    lazy var closeB: UIButton = {
        let v = UIButton()
        v.translatesAutoresizingMaskIntoConstraints = false
        v.setTitle("Close", for: .normal)
        v.setTitleColor(.cyan, for: .normal)
        return v
    }()
    
    init(text: String, close: @escaping () -> Void) {
        self.text = text
        self.close = close
        super.init(frame: .zero)
        configure()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configure() {
        addSubview(label)
        addSubview(closeB)
        
        NSLayoutConstraint.activate([
            label.topAnchor.constraint(equalTo: topAnchor, constant: 32),
            label.centerXAnchor.constraint(equalTo: centerXAnchor),
            
            closeB.centerXAnchor.constraint(equalTo: centerXAnchor),
            closeB.topAnchor.constraint(equalTo: label.bottomAnchor, constant: 16),
            closeB.heightAnchor.constraint(equalToConstant: 50)
        ])
        
        closeB.addTarget(self, action: #selector(closeTap(_:)), for: .touchUpInside)
        label.text = text
        
        
    }
    
    @objc private func closeTap(_ sender: UIButton) {
        close()
    }
}
