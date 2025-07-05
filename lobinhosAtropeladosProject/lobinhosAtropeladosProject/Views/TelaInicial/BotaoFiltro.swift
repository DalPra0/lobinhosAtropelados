//
//  BotaoFiltro.swift
//  lobinhosAtropeladosProject
//
//  Created by Lucas Dal Pra Brascher on 05/07/25.
//

import SwiftUI

struct BotaoFiltro: View {
    let titulo: String
    @Binding var filtroSelecionado: String
    
    var isSelected: Bool {
        titulo == filtroSelecionado
    }
    
    var body: some View {
        Button(action: {
            filtroSelecionado = titulo
        }) {
            HStack{
                Spacer()
                Text(titulo)
                    .font(.system(size: 15))
                    .fontWeight(.semibold)
                    .foregroundColor(isSelected ? .white : Color("corPrimaria"))
                Spacer()
                    
            }
            .padding(.vertical, 7)
            .background(
                RoundedRectangle(cornerRadius: 12.0)
                    .fill(isSelected ? Color("corPrimaria") : Color.clear)
            )
            .overlay(
                RoundedRectangle(cornerRadius: 12.0)
                    .stroke(Color("corPrimaria"), lineWidth: 1.0)
            )
        }
    }
}
