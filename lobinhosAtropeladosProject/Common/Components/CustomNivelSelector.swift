//
//  CustomNivelSelector.swift
//  lobinhosAtropeladosProject
//
//  Created by Ruby Rosa on 04/07/25.
//

import SwiftUI

struct CustomNivelSelector: View {
    @Binding var selected: Int // valor de 1 a 5

    var body: some View {
        HStack {
            ForEach(1...5, id: \.self) { i in
                Button(action: {
                    selected = i
                }) {
                    Text("\(i)")
                        .font(.title)
                        .fontWeight(.semibold)
                        .frame(width: 48, height: 48)
                        .background(selected == i ? Color("corPrimaria") : Color.clear)
                        .foregroundColor(selected == i ? .white : Color("corPrimaria"))
                        .overlay(
                            Circle()
                                .stroke(Color("corPrimaria"), lineWidth: 2)
                        )
                        .clipShape(Circle())
                }

                if i < 5 {
                    Spacer(minLength: 0)
                }
            }
        }
        .padding(.horizontal)
    }
}

#Preview {
    PerfilView()
}
