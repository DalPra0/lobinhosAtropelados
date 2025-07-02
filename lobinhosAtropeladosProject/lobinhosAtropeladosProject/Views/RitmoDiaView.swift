//
//  RitmoDiaView.swift
//  lobinhosAtropeladosProject
//
//  Created by Gemini on 01/07/25.
//
//  Esta é a nova tela para o usuário definir o ritmo e o tempo do dia.
//

import SwiftUI

struct RitmoDiaView: View {
    // Referência ao nosso manager para comunicar a escolha.
    @ObservedObject var ritmoManager: RitmoDiaManager
    
    // Estados locais para guardar a seleção na tela antes de confirmar.
    @State private var selecaoRitmo: RitmoDiario? = nil
    @State private var horas: String = "00"
    @State private var minutos: String = "00"

    var body: some View {
        ZStack(alignment: .topTrailing) {
            // Usa a cor de fundo do seu design.
            Color("corFundo").ignoresSafeArea()
            
            ScrollView {
                VStack(spacing: 24) {
                    // --- Cabeçalho ---
                    VStack(spacing: 8) {
                        Text("Olá, Ana!") // TO-DO: Substituir por nome do usuário
                            .font(.secularOne(size: 32))
                        
                        Text("Qual o ritmo você prefere para o seu dia hoje?")
                            .font(.secularOne(size: 20))
                            .multilineTextAlignment(.center)
                    }
                    .padding(.top, 40)
                    
                    Text("Fique tranquilo(a)! Essas informações podem ser alteradas depois.")
                        .font(.body)
                        .foregroundColor(Color("corTextoSecundario"))
                        .multilineTextAlignment(.center)
                    
                    // --- Botões de Ritmo ---
                    VStack(spacing: 16) {
                        BotaoRitmo(titulo: "TRANQUILO", descricao: "Um dia tranquilo para manter o foco sem sobrecarga.", cor: Color("corDestaqueBaixa"), ritmo: .tranquilo, selecao: $selecaoRitmo)
                        BotaoRitmo(titulo: "MODERADO", descricao: "Vamos organizar um dia produtivo, com um bom número de tarefas, mas sem exagerar.", cor: Color("corDestaqueMedia"), ritmo: .moderado, selecao: $selecaoRitmo)
                        BotaoRitmo(titulo: "INTENSO", descricao: "Vamos encaixar o máximo de tarefas possível para dar aquele gás nos estudos ou adiantar pendências.", cor: Color("corDestaqueAlta"), ritmo: .intenso, selecao: $selecaoRitmo)
                    }
                    .padding(.top)

                    // --- Seletor de Tempo ---
                    VStack(spacing: 8) {
                        Text("E quanto tempo deseja reservar para suas tarefas?")
                            .font(.secularOne(size: 20))
                            .multilineTextAlignment(.center)
                        
                        HStack {
                            TextField("00", text: $horas)
                                .font(.secularOne(size: 48))
                                .keyboardType(.numberPad)
                                .multilineTextAlignment(.trailing)
                                .frame(width: 80)
                            
                            Text(":")
                                .font(.secularOne(size: 48))
                                .padding(.bottom, 8)
                            
                            TextField("00", text: $minutos)
                                .font(.secularOne(size: 48))
                                .keyboardType(.numberPad)
                                .frame(width: 80)
                        }
                        .padding(.horizontal, 40)
                        .padding(.vertical, 10)
                        .background(Color("corCardSecundario").opacity(0.5))
                        .cornerRadius(16)
                    }
                    .padding(.top)

                    // --- Botão de Concluir ---
                    Button("CONCLUÍDO") {
                        let horasInt = Int(horas) ?? 0
                        let minutosInt = Int(minutos) ?? 0
                        let tempoTotal = (horasInt * 60) + minutosInt
                        
                        ritmoManager.concluirSelecaoDeRitmo(ritmo: selecaoRitmo, tempoEmMinutos: tempoTotal)
                    }
                    .font(.secularOne(size: 18))
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color("corCardSecundario"))
                    .cornerRadius(16)
                    .disabled(selecaoRitmo == nil) // Desabilitado se nenhuma opção for escolhida
                    .opacity(selecaoRitmo == nil ? 0.6 : 1.0)
                }
                .padding(24)
            }
            .foregroundColor(Color("corTextoPrimario"))
            
            // Botão de Fechar (X) no canto superior direito
            Button(action: { ritmoManager.concluirSelecaoDeRitmo(ritmo: nil, tempoEmMinutos: nil) }) {
                Image(systemName: "xmark.circle.fill")
                    .font(.title)
                    .foregroundColor(Color("corTextoSecundario").opacity(0.8))
            }
            .padding()
        }
    }
}

// View auxiliar para os botões de ritmo, para não repetir código.
private struct BotaoRitmo: View {
    let titulo: String
    let descricao: String
    let cor: Color
    let ritmo: RitmoDiario
    @Binding var selecao: RitmoDiario?
    
    var isSelected: Bool {
        selecao == ritmo
    }
    
    var body: some View {
        Button(action: {
            withAnimation(.spring()) {
                selecao = ritmo
            }
        }) {
            VStack(spacing: 4) {
                Text(titulo)
                    .font(.secularOne(size: 16))
                Text(descricao)
                    .font(.caption)
                    .multilineTextAlignment(.center)
            }
            .padding()
            .frame(maxWidth: .infinity)
            .foregroundColor(isSelected ? .black : Color("corTextoPrimario"))
            .background(isSelected ? cor : Color("corCardSecundario"))
            .cornerRadius(16)
            .overlay(
                RoundedRectangle(cornerRadius: 16)
                    .stroke(cor, lineWidth: isSelected ? 3 : 0)
            )
        }
    }
}


#Preview {
    RitmoDiaView(ritmoManager: RitmoDiaManager.shared)
}
