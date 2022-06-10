//
//  Button.swift
//  matte
//
//  Created by Jeff Reiner on 6/10/22.
//

import SwiftUI

struct PillButton: View {
    var text: String
    var onClick: () -> Void
    
    var body: some View {
        Button(action: onClick) {
            Text(text)
                .fontWeight(.semibold)
                .foregroundColor(.black)
                .padding(.horizontal, 22)
                .padding(.vertical, 10)
                .background(.white)
                .cornerRadius(.greatestFiniteMagnitude)
        }
    }
}

struct PillButton_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            PillButton(text: "Print Hello", onClick: { print("Hello") })
                .previewLayout(PreviewLayout.sizeThatFits)
                .padding()
                .background(.black)
            
            PillButton(text: "Print Hello", onClick: { print("Hello") })
                .previewLayout(PreviewLayout.sizeThatFits)
                .padding()
                .background(.purple)
        }
    }
}
