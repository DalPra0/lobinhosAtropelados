import SwiftUI

struct TelaInicialView: View {
    @ObservedObject var tarefaModel = TarefaModel.shared
    @ObservedObject var userModel = UserModel.shared
    
    // State para os modais
    @State private var showModal_add = false
    @State private var showModal = false
    @State private var showModal_aux = false // Variável auxiliar para o bug do modal
    
    // State para a lista de tarefas
    @State private var filtro: String = "Todas"
    @State private var tarefa_id_edicao: UUID? = nil // Alterado para opcional
    @State private var id_tarefa_expandida: UUID? = nil // Alterado para opcional

    // Cores e textos baseados no modo do usuário
    var cor: Color {
        switch userModel.user.modo_selecionado {
        case 1: return .corModoTranquilo
        case 2: return .corModoModerado
        case 3: return .corModoIntenso
        default: return .gray
        }
    }
    
    var texto: String {
        // Esta lógica depende de como o `modo_selecionado` é definido no cadastro.
        // Assumindo uma correspondência com o estilo de organização.
        switch userModel.user.modo_selecionado {
        case 1: return "tranquilo"
        case 2: return "moderado"
        case 3: return "intenso"
        default: return "a escolher"
        }
    }
    
    // Lógica de filtragem corrigida e implementada
    private var tarefasFiltradas: [Tarefa] {
        if filtro == "Todas" {
            return tarefaModel.tarefas.filter { !$0.concluida }
        }
        
        if filtro == "Concluídas" {
            return tarefaModel.tarefas.filter { $0.concluida }
        }
        
        if filtro == "Para hoje" {
            // Lógica para "Para hoje" implementada
            return tarefaModel.tarefas.filter { tarefa in
                return Calendar.current.isDateInToday(tarefa.data_entrega) && !tarefa.concluida
            }
        }
        
        // Fallback caso nenhum filtro corresponda
        return tarefaModel.tarefas.filter { !$0.concluida }
    }
    
    var body: some View {
        ZStack {
            Color.corFundo
                .ignoresSafeArea()
            
            VStack(alignment: .leading, spacing: 32) {
                // Cabeçalho com perfil/nome etc.
                HStack(spacing: 8) {
                    VStack(alignment: .leading, spacing: 5) {
                        Text("Olá \(userModel.user.nome),")
                            .font(.body)
                            .fontWeight(.semibold)
                            .foregroundColor(.corTextoSecundario)
                        Text("Seu dia será \(texto)!")
                            .font(.system(size: 22))
                            .fontWeight(.semibold)
                            .foregroundColor(cor)
                        
                        Button {
                            // Ação de alterar modo (IMPLEMENTAR)
                        } label: {
                            Text("Clique aqui para alterar")
                                .font(.system(size: 13))
                                .fontWeight(.regular)
                                .foregroundColor(.corTextoTerciario)
                        }
                    }
                    
                    Spacer()
                    
                    Button {
                        // Ação de ir para o perfil (IMPLEMENTAR)
                    } label: {
                        Image(systemName: "person")
                            .foregroundColor(.corPrimaria)
                            .font(.system(size: 30))
                            .bold()
                    }
                }
                
                VStack(alignment: .leading, spacing: 24) {
                    Text("Minhas tarefas")
                        .bold()
                        .font(.system(size: 25))
                    
                    // Filtros
                    HStack(spacing: 8) {
                        BotaoFiltro(titulo: "Para hoje", filtroSelecionado: $filtro)
                        BotaoFiltro(titulo: "Concluídas", filtroSelecionado: $filtro)
                        BotaoFiltro(titulo: "Todas", filtroSelecionado: $filtro)
                    }
                    
                    // --- LISTA DE TAREFAS CORRIGIDA ---
                    List(tarefasFiltradas) { tarefa in
                        CelulaDaTarefaView(
                            tarefa: tarefa,
                            tarefaExpandidaID: $id_tarefa_expandida,
                            tarefaParaEditar: $tarefa_id_edicao,
                            showEditModal: $showModal_aux
                        )
                        .listRowSeparator(.hidden)
                        .listRowInsets(EdgeInsets(top: 8, leading: 0, bottom: 8, trailing: 0))
                        .listRowBackground(Color.corFundo)
                    }
                    .listStyle(.plain)
                    .scrollContentBackground(.hidden)
                }
            }
            .padding(.horizontal, 24)
            .padding(.top, 64)
            
            // Botão flutuante para adicionar tarefa
            VStack {
                Spacer()
                HStack {
                    Spacer()
                    Button {
                        showModal_add = true
                    } label: {
                        Image(systemName: "plus.circle.fill")
                            .foregroundColor(.corPrimaria)
                            .font(.system(size: 45))
                    }
                    .padding(.horizontal, 16)
                    .padding(.vertical, 20)
                }
            }
            
            // Indicador de carregamento da IA
            if tarefaModel.estaPriorizando {
                VStack {
                    ProgressView()
                        .scaleEffect(1.5)
                    Text("Priorizando tarefas...")
                        .padding(.top, 8)
                }
                .padding(20)
                .background(.thinMaterial)
                .cornerRadius(10)
            }
        }
        .navigationBarHidden(true)
        .sheet(isPresented: $showModal_add) {
            TarefaAddModalView()
                .presentationDetents([.large])
        }
        .sheet(isPresented: $showModal) {
            if let id = tarefa_id_edicao {
                TelaEditModalView(id: id)
                    .presentationDetents([.large])
            }
        }
        // Lógica para contornar bug do modal de edição
        .onChange(of: showModal_aux) { newValue in
            if newValue {
                showModal = true
            }
        }
        .onChange(of: showModal) { newValue in
            if !newValue {
                showModal_aux = false
                tarefa_id_edicao = nil
            }
        }
    }
}

#Preview {
    TelaInicialView()
}
