//
//  PerfilView.swift
//  lobinhosAtropeladosProject
//
//  Created by Beatriz Perotto Muniz on 26/06/25.
//

import SwiftUI

struct PerfilView: View {
    @ObservedObject var tarefaModel = TarefaModel.shared

    @State private var isEditing = false
    @State private var nome: String = "Mari Oliveira"
    @State private var bio: String = "Estudante de Psicologia do 5º período na UFPR em tempo integral e faço estágio de 20h semanais."

    var body: some View {
        ZStack {
            Color(.systemBackground)
                .ignoresSafeArea()

            VStack(spacing: 24) {
                Spacer().frame(height: 32)

                Image(systemName: "person.crop.circle.fill")
                    .resizable()
                    .frame(width: 120, height: 120)
                    .foregroundColor(Color("corSelect"))

                VStack(spacing: 4) {
                    if isEditing {
                        VStack(spacing: 2) {
                            CustomTextField( // ALTERADO
                                placeholder: "Nome",
                                text: $nome
                            )
                            .frame(width: 200)

                            Rectangle()
                                .frame(width: 200, height: 1)
                                .foregroundColor(.gray.opacity(0.4))
                        }
                    } else {
                        Text(nome)
                            .font(.title2.bold())
                            .multilineTextAlignment(.center)
                    }

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

                VStack(alignment: .leading, spacing: 4) {
                    Text("Sobre mim:")
                        .font(.title3.bold())
                        .foregroundColor(.secondary)
                        .padding(.leading, 16)
                        .padding(.bottom, isEditing ? 2 : -12)

                    CustomTextBox( // ALTERADO
                        placeholder: "Sobre mim",
                        text: $bio,
                        isEditable: isEditing // NOVO
                    )
                    .frame(height: 100)
                    .padding(.horizontal, 4)
                }
                .padding(.horizontal, 16)

                Spacer()

                if isEditing {
                    HStack(spacing: 16) {
                        CustomButton(
                            title: "Cancelar",
                            style: .strokeButton,
                            action: {
                                withAnimation {
                                    isEditing = false
                                }
                            }
                        )

                        CustomButton(
                            title: "Salvar",
                            style: .filledButton,
                            action: {
                                withAnimation {
                                    isEditing = false
                                }
                            }
                        )
                    }
                    .padding(.horizontal)
                }
            }
        }
    }
}

#Preview {
    PerfilView()
}
