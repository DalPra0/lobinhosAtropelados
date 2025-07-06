//
//  AlterarModoView.swift
//  lobinhosAtropeladosProject
//
//  Created by Lucas Dal Pra Brascher on 05/07/25.
//

import SwiftUI

struct AlterarModoView: View {
    @ObservedObject var userModel = UserModel.shared
    @Environment(\.dismiss) var dismiss

    // State local para guardar a seleção antes de salvar
    @State private var estiloSelecionado: String

    // Mapeamento das opções para os modos (Int)
    private let opcoes: [String: Int] = [
        "Poucas tarefas e um dia tranquilo.": 1,
        "Algumas tarefas, mas sem sobrecarregar meu dia.": 2,
        "Ser produtivo, mas ter pausas para um descanso.": 2, // Também é moderado
        "Foco total, quero finalizar minhas tarefas o mais rápido possível.": 3
    ]

    init() {
        // Inicializa a tela com a seleção atual do usuário
        _estiloSelecionado = State(initialValue: UserModel.shared.user.estiloOrganizacao ?? "")
    }

    var body: some View {
        ZStack {
            Color("corFundo").ignoresSafeArea()

            VStack(spacing: 0) {
                // Cabeçalho com botão de fechar
                HStack {
                    Spacer()
                    Button(action: { dismiss() }) {
                        Image(systemName: "xmark")
                            .foregroundColor(Color("corTextoSecundario"))
                            .font(.title3)
                    }
                }
                .padding([.top, .horizontal])
                .padding(.bottom, 20)

                // Reutiliza a view de seleção do cadastro
                CadastroStep2View(estiloOrganizacao: $estiloSelecionado)

                Spacer()

                // Botão de Salvar
                Button(action: salvarAlteracao) {
                    Text("SALVAR RITMO")
                        .font(.system(size: 16, weight: .bold))
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(estiloSelecionado.isEmpty ? Color.gray.opacity(0.5) : Color("corPrimaria"))
                        .foregroundColor(Color("corFundo"))
                        .cornerRadius(16)
                }
                .disabled(estiloSelecionado.isEmpty)
                .padding()
            }
        }
    }

    private func salvarAlteracao() {
        // Salva a string do estilo de organização
        userModel.atualizarEstiloOrganizacao(estilo: estiloSelecionado)
        
        // Salva o número correspondente ao modo
        if let modo = opcoes[estiloSelecionado] {
            userModel.atualizar_modo(modo: modo)
        }
        
        // Fecha a tela
        dismiss()
    }
}

#Preview {
    AlterarModoView()
}
