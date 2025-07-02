//
//  PerfilView.swift
//  lobinhosAtropeladosProject
//
//  Created by Beatriz Perotto Muniz on 26/06/25.
//
//  Atualizado para usar as cores e fontes do design do projeto.
//

import SwiftUI

struct PerfilView: View {

    @State private var isEditing = false
    @State private var nome: String = "Mari Oliveira"
    @State private var bio: String = "Estudante de Psicologia do 5º período na UFPR em tempo integral e faço estágio de 20h semanais."

    var body: some View {
        ZStack {
            // Usa a cor de fundo principal do app
            Color("corFundo").ignoresSafeArea()

            VStack(spacing: 24) {
                Spacer().frame(height: 32)

                Image(systemName: "person.crop.circle.fill")
                    .resizable()
                    .frame(width: 120, height: 120)
                    .foregroundColor(Color("corDestaqueMedia"))

                VStack(spacing: 4) {
                    if isEditing {
                        VStack(spacing: 2) {
                            TextField("Nome", text: $nome)
                                .font(.secularOne(size: 22))
                                .multilineTextAlignment(.center)
                                .frame(width: 250)
                            
                            Rectangle()
                                .frame(width: 250, height: 1)
                                .foregroundColor(Color("corTextoSecundario").opacity(0.4))
                        }
                    } else {
                        Text(nome)
                            .font(.secularOne(size: 22))
                            .multilineTextAlignment(.center)
                    }

                    Button(action: {
                        withAnimation {
                            isEditing = true
                        }
                    }) {
                        HStack(spacing: 4) {
                            Text("Editar perfil")
                            Image(systemName: "pencil")
                        }
                        .font(.subheadline)
                        .foregroundColor(Color("corTextoSecundario"))
                    }
                    .opacity(isEditing ? 0 : 1)
                }

                VStack(alignment: .leading, spacing: 8) {
                    Text("Sobre mim:")
                        .font(.secularOne(size: 18))
                        .foregroundColor(Color("corTextoSecundario"))
                        .padding(.leading, 12)

                    TextEditor(text: $bio)
                        .scrollContentBackground(.hidden) // Torna o fundo do TextEditor transparente
                        .frame(height: 120)
                        .padding(8)
                        .disabled(!isEditing)
                        .background(
                            RoundedRectangle(cornerRadius: 12)
                                .fill(Color("corCardSecundario").opacity(0.5))
                        )
                        .overlay(
                            RoundedRectangle(cornerRadius: 12)
                                .stroke(isEditing ? Color("corDestaqueMedia") : Color.clear, lineWidth: 1)
                        )
                }
                .padding(.horizontal, 16)
                
                Spacer()

                if isEditing {
                    HStack(spacing: 16) {
                        Button("Cancelar") {
                            withAnimation {
                                isEditing = false
                                // TO-DO: Descartar alterações
                            }
                        }
                        .buttonStyle(ModalButtonStyle(tipo: .cancelar))

                        Button("Salvar") {
                            withAnimation {
                                isEditing = false
                                // TO-DO: Salvar alterações
                            }
                        }
                        .buttonStyle(ModalButtonStyle(tipo: .salvar))
                    }
                    .padding(.horizontal)
                }

                Spacer().frame(height: 20)
            }
            .foregroundColor(Color("corTextoPrimario"))
        }
    }
}

// Reutilizando o estilo de botão da tela de Adicionar/Editar para consistência
private struct ModalButtonStyle: ButtonStyle {
    enum TipoBotao { case salvar, cancelar }
    var tipo: TipoBotao
    
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .font(.secularOne(size: 16))
            .frame(maxWidth: .infinity)
            .padding(.vertical, 12)
            .background(tipo == .salvar ? Color("corDestaqueBaixa") : Color("corDestaqueAlta").opacity(0.3))
            .foregroundColor(tipo == .salvar ? .black : Color("corDestaqueAlta"))
            .cornerRadius(40)
            .scaleEffect(configuration.isPressed ? 0.97 : 1.0)
    }
}


#Preview {
    PerfilView()
}
