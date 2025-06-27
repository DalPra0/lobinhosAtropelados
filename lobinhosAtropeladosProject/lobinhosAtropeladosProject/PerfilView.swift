//
//  PerfilView.swift
//  lobinhosAtropeladosProject
//
//  Created by Beatriz Perotto Muniz on 26/06/25.
//

import SwiftUI

struct PerfilView: View {

    @State private var isEditing = false
    @State private var nome: String = "Mari Oliveira"
    @State private var bio: String = "Estudante de Psicologia do 5º período na UFPR em tempo integral e faço estágio de 20h semanais."

    var body: some View {
            ZStack {
                Color(.systemBackground)
                    .ignoresSafeArea()

                VStack(spacing: 24) {
                    Spacer().frame(height: 32)

                    // Ícone do perfil
                    Image(systemName: "person.crop.circle.fill")
                        .resizable()
                        .frame(width: 120, height: 120)
                        .foregroundColor(.blue)

                    // Nome + botão editar
                    VStack(spacing: 4) {
                        if isEditing {
                            VStack(spacing: 2) {
                                TextField("Nome", text: $nome)
                                    .font(.title2.bold())
                                    .multilineTextAlignment(.center)
                                    .frame(width: 200) // Largura parecida com o texto
                                
                                Rectangle()
                                    .frame(width: 200, height: 1)
                                    .foregroundColor(.gray.opacity(0.4))
                            }
                        } else {
                            Text(nome)
                                .font(.title2.bold())
                                .multilineTextAlignment(.center)
                        }

                        // Botão Editar perfil (invisivel mas ocupa espaço)
                        Button(action: {
                            withAnimation {
                                isEditing = true
                            }
                        }) {
                            HStack(spacing: 4) {
                                Text("Editar perfil")
                                    .font(.subheadline)
                                Image(systemName: "pencil")
                                    .font(.subheadline)
                            }
                            .foregroundColor(.gray)
                        }
                        .opacity(isEditing ? 0 : 1)
                    }

                    // BIO
                    VStack(alignment: .leading, spacing: 4) {
                        Text("Sobre mim:")
                            .font(.title3.bold())
                            .foregroundColor(.secondary)
                            .padding(.leading, 12)
                            .padding(.bottom, isEditing ? 2 : -12)

                        TextEditor(text: $bio)
                            .frame(height: 100)
                            .padding(8)
                            .disabled(!isEditing)
                            .background(
                                RoundedRectangle(cornerRadius: 8)
                                    .stroke(isEditing ? Color.gray.opacity(0.3) : Color.clear)
                            )
                    }
                    .padding(.horizontal, 16)
                    
                    Spacer()

                    // Botões cancelar e salvar
                    if isEditing {
                        HStack(spacing: 16) {
                            Button(action: {
                                withAnimation {
                                    isEditing = false
                                }
                            }) {
                                Text("Cancelar")
                                    .frame(maxWidth: .infinity)
                                    .frame(height: 48)
                                    .background(Color(.systemGray5))
                                    .foregroundColor(.gray)
                                    .cornerRadius(16)
                            }

                            Button(action: {
                                withAnimation {
                                    isEditing = false
                                }
                                // salvar alterações aqui
                            }) {
                                Text("Salvar")
                                    .frame(maxWidth: .infinity)
                                    .frame(height: 48)
                                    .background(Color(red: 0.8, green: 0.9, blue: 1.0))
                                    .foregroundColor(.blue)
                                    .cornerRadius(16)
                            }
                        }
                        .padding(.horizontal)
                    }

                    Spacer().frame(height: 20)
                }
            }
        }
    }

#Preview {
    PerfilView()
}
