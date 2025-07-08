//
//  AjudaView.swift
//  lobinhosAtropeladosProject
//
//  Created by Beatriz Perotto Muniz on 08/07/25.
//

import SwiftUI

struct AjudaView: View {
    
    @Environment(\.dismiss) var dismiss//para fazer funcao de back

    
    var body: some View {
        ZStack {
            Color("corFundo").ignoresSafeArea()
            
            ScrollView {
                VStack(alignment:.leading, spacing : 24){
                    HStack {
                        Button(action: { dismiss() }) {
                            Image(systemName: "chevron.left")
                                .foregroundColor(.corPrimaria)
                                .font(.system(size: 22))
                                .bold()
                        }
                        Spacer()
                    }
                    .padding(.top, 20)
                    
                    Text("Como usar o Gimo")
                        .font(.system(size: 30, weight: .bold))
                        .foregroundColor(Color("corPrimaria"))
                    
                    VStack(alignment:.leading, spacing : 12){
                        
                        Text("Para concluir")
                            .font(.system(size: 20))
                            .fontWeight(.semibold)
                            .foregroundColor(Color("corPrimaria"))
                        Text("Para concluir uma tarefa, basta tocar no círculo no canto esquerdo da tarefa.")
                            .font(.system(size: 18))
                            .foregroundColor(Color("corTextoSecundario"))
                        
                        Spacer()
                        
                        Text("Para ver os detalhes")
                            .font(.system(size: 20))
                            .fontWeight(.semibold)
                            .foregroundColor(Color("corPrimaria"))
                        Text("Toda tarefa tem informações extras. Toque no corpo de uma tarefa para expandir e ver a descrição, o prazo e a dificuldade. Toque novamente para fechar.")
                            .font(.system(size: 18))
                            .foregroundColor(Color("corTextoSecundario"))
                        
                        Spacer()

                        
                        Text("Para excluir ou editar")
                            .font(.system(size: 20))
                            .fontWeight(.semibold)
                            .foregroundColor(Color("corPrimaria"))
                        Text("Deslize o dedo da direita para a esquerda sobre a tarefa para revelar as opções.")
                            .font(.system(size: 18))
                            .foregroundColor(Color("corTextoSecundario"))
                        
                        Spacer()

                        
                        Text("Para adicionar tarefas")
                            .font(.system(size: 20))
                            .fontWeight(.semibold)
                            .foregroundColor(Color("corPrimaria"))
                        Text("Para adicionar uma tarefa, toque no botão azul com o sinal de \"+\" no canto inferior direito para cadastrar suas próprias atividades da faculdade.")
                            .font(.system(size: 18))
                            .foregroundColor(Color("corTextoSecundario"))
                        
                        Spacer()

                        
                        Text("Navegando entre listas")
                            .font(.system(size: 20))
                            .fontWeight(.semibold)
                            .foregroundColor(Color("corPrimaria"))
                        Text("Na tela inicial, você pode usar os filtros para alternar entre as tarefas que eu priorizei \"Para hoje\", \"Todas\" as suas tarefas pendentes ou as que você já finalizou em \"Concluídas\".")
                            .font(.system(size: 18))
                            .foregroundColor(Color("corTextoSecundario"))
                        
                        Spacer()

                        
                        Text("Para ajustar seu perfil")
                            .font(.system(size: 20))
                            .fontWeight(.semibold)
                            .foregroundColor(Color("corPrimaria"))
                        Text("Para ajustar seu período ou curso, clique no ícone de perfil no canto superior direito da tela inicial. Em seguida, escolha entre \"Período\" ou \"Curso\" e altere o seu valor clicando no botão de \"editar\".")
                            .font(.system(size: 18))
                            .foregroundColor(Color("corTextoSecundario"))
                        
                        Spacer()

                        
                        Text("Para ajustar seu ritmo")
                            .font(.system(size: 20))
                            .fontWeight(.semibold)
                            .foregroundColor(Color("corPrimaria"))
                        Text("Se o seu dia estiver mais corrido ou mais leve, clique em \"Alterar seu ritmo\" logo abaixo do seu nome, na tela inicial, para que eu possa ajustar o plano para você.")
                            .font(.system(size: 18))
                            .foregroundColor(Color("corTextoSecundario"))
                    }
                }
                .padding(.horizontal, 24)
                .padding(.bottom, 40)
            }
        }
        .navigationBarBackButtonHidden(true)
    }
}

#Preview {
    AjudaView()
}
