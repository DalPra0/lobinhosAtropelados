import SwiftUI

struct TelaInicialView: View {
    @ObservedObject var tarefaModel = TarefaModel.shared
    @ObservedObject var userModel = UserModel.shared
    
    // MARK: - States
    @State private var showModal_add = false
    @State private var showModal = false
    @State private var showModal_aux = false
    
    @State private var filtro: String = "Todas"
    @State private var tarefa_id_edicao: UUID? = nil
    @State private var id_tarefa_expandida: UUID? = nil
    
    @State private var mostrandoAlertaLimpar = false
    @State private var mostrandoTelaPerfil = false // State para controlar a exibição da tela de perfil
    
    // MARK: - Computed Properties
    private var tarefasPendentesFiltradas: [Tarefa] {
        if filtro == "Para hoje" {
            return tarefaModel.tarefas.filter { tarefa in
                return Calendar.current.isDateInToday(tarefa.data_entrega) && !tarefa.concluida
            }
        }
        // "Todas" e qualquer outro caso mostram as não concluídas
        return tarefaModel.tarefas.filter { !$0.concluida }
    }
    
    private var tarefasConcluidasAgrupadas: [Date: [Tarefa]] {
        let tarefasConcluidas = tarefaModel.tarefas.filter { $0.concluida && $0.data_conclusao != nil }
        
        let groupedDictionary = Dictionary(grouping: tarefasConcluidas) { tarefa in
            // Normaliza a data para agrupar por dia, ignorando a hora
            return Calendar.current.startOfDay(for: tarefa.data_conclusao!)
        }
        return groupedDictionary
    }
    
    private var datasOrdenadas: [Date] {
        // Ordena as chaves do dicionário (as datas) em ordem decrescente
        return tarefasConcluidasAgrupadas.keys.sorted(by: >)
    }

    var body: some View {
        ZStack {
            Color.corFundo
                .ignoresSafeArea()
            
            VStack(alignment: .leading, spacing: 32) {
                cabecalhoView
                
                VStack(alignment: .leading, spacing: 24) {
                    Text("Minhas tarefas")
                        .bold()
                        .font(.system(size: 25))
                    
                    filtrosView
                    
                    if filtro == "Concluídas" {
                        listaDeConcluidasView
                    } else {
                        listaDePendentesView
                    }
                }
            }
            .padding(.horizontal, 24)
            .padding(.top, 64)
            
            botaoAdicionarView
            
            if tarefaModel.estaPriorizando {
                indicadorDeProgressoView
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
        .sheet(isPresented: $mostrandoTelaPerfil) { // Abre a tela de perfil
            PerfilView()
        }
        .onChange(of: showModal_aux) { newValue in
            if newValue { showModal = true }
        }
        .onChange(of: showModal) { newValue in
            if !newValue {
                showModal_aux = false
                tarefa_id_edicao = nil
            }
        }
        .alert("Atenção", isPresented: $mostrandoAlertaLimpar) {
            Button("Apagar Tudo", role: .destructive) {
                tarefaModel.limparTarefasConcluidas()
            }
            Button("Cancelar", role: .cancel) { }
        } message: {
            Text("Isso apagará seu histórico de tarefas concluídas e pode afetar a precisão da priorização futura. Deseja continuar?")
        }
    }
    
    // MARK: - Subviews
    private var cabecalhoView: some View {
        HStack(spacing: 8) {
            VStack(alignment: .leading, spacing: 5) {
                Text("Olá \(userModel.user.nome),")
                    .font(.body)
                    .fontWeight(.semibold)
                    .foregroundColor(.corTextoSecundario)
                Text("Seu dia será intenso!") // Exemplo, pode ser dinâmico
                    .font(.system(size: 22))
                    .fontWeight(.semibold)
                    .foregroundColor(.corModoIntenso) // Exemplo
                
                Button("Clique aqui para alterar") { /* Ação */ }
                    .font(.system(size: 13))
                    .fontWeight(.regular)
                    .foregroundColor(.corTextoTerciario)
            }
            Spacer()
            Button(action: { mostrandoTelaPerfil = true }) { // Ação para abrir o perfil
                Image(systemName: "person")
                    .foregroundColor(.corPrimaria)
                    .font(.system(size: 30)).bold()
            }
        }
    }
    
    private var filtrosView: some View {
        HStack(spacing: 8) {
            BotaoFiltro(titulo: "Para hoje", filtroSelecionado: $filtro)
            BotaoFiltro(titulo: "Concluídas", filtroSelecionado: $filtro)
            BotaoFiltro(titulo: "Todas", filtroSelecionado: $filtro)
        }
    }
    
    private var listaDePendentesView: some View {
        ScrollView {
            LazyVStack(spacing: 12) {
                ForEach(tarefasPendentesFiltradas) { tarefa in
                    CelulaDaTarefaView(
                        tarefa: tarefa,
                        tarefaExpandidaID: $id_tarefa_expandida,
                        tarefaParaEditar: $tarefa_id_edicao,
                        showEditModal: $showModal_aux
                    )
                }
            }
        }
        .scrollIndicators(.hidden)
    }
    
    private var listaDeConcluidasView: some View {
        ScrollView {
            LazyVStack(alignment: .leading, spacing: 16) {
                if datasOrdenadas.isEmpty {
                    Text("Nenhuma tarefa concluída ainda.")
                        .foregroundColor(.corTextoSecundario)
                        .frame(maxWidth: .infinity, alignment: .center)
                        .padding(.top, 40)
                } else {
                    ForEach(datasOrdenadas, id: \.self) { data in
                        Section {
                            ForEach(tarefasConcluidasAgrupadas[data] ?? []) { tarefa in
                                CelulaDaTarefaView(
                                    tarefa: tarefa,
                                    tarefaExpandidaID: .constant(nil),
                                    tarefaParaEditar: .constant(nil),
                                    showEditModal: .constant(false)
                                )
                            }
                        } header: {
                            HStack {
                                Text(data, style: .date)
                                    .font(.headline)
                                    .foregroundColor(.corTextoSecundario)
                                Spacer()
                                Button("Limpar") {
                                    mostrandoAlertaLimpar = true
                                }
                                .font(.caption)
                                .foregroundColor(.red)
                            }
                        }
                    }
                }
            }
        }
        .scrollIndicators(.hidden)
    }
    
    private var botaoAdicionarView: some View {
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
    }
    
    private var indicadorDeProgressoView: some View {
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

#Preview {
    TelaInicialView()
}
