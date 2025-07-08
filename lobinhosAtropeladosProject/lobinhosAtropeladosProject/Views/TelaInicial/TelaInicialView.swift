import SwiftUI

struct TelaInicialView: View {
    @ObservedObject var tarefaModel = TarefaModel.shared
    @ObservedObject var userModel = UserModel.shared
    
    @State private var showModal_add = false
    @State private var showModal = false
    @State private var showModal_aux = false
    
    @State private var filtro: String = "Para hoje"
    @State private var tarefa_id_edicao: UUID? = nil
    @State private var id_tarefa_expandida: UUID? = nil
    
    @State private var mostrandoAlertaLimpar = false
    @State private var mostrandoTelaPerfil = false
    @State private var mostrandoTelaAlterarModo = false
    
    private var textoModo: String {
        switch userModel.user.modo_selecionado {
        case 1: return "Seu dia será tranquilo!"
        case 2: return "Seu dia será moderado!"
        case 3: return "Seu dia será intenso!"
        default: return "Defina seu ritmo de hoje!"
        }
    }
    
    private var corModo: Color {
        switch userModel.user.modo_selecionado {
        case 1: return Color("corModoTranquilo")
        case 2: return Color("corModoModerado")
        case 3: return Color("corModoIntenso")
        default: return .gray
        }
    }
    
    private var tarefasFiltradas: [Tarefa] {
        if filtro == "Para hoje" {
            return tarefaModel.tarefas.filter { $0.fazParteDoPlanoDeHoje && !$0.concluida }
        }
        return tarefaModel.tarefas.filter { !$0.concluida }
    }
    
    private var tarefasConcluidasAgrupadas: [Date: [Tarefa]] {
        let tarefasConcluidas = tarefaModel.tarefas.filter { $0.concluida && $0.data_conclusao != nil }
        let groupedDictionary = Dictionary(grouping: tarefasConcluidas) { tarefa in
            return Calendar.current.startOfDay(for: tarefa.data_conclusao!)
        }
        return groupedDictionary
    }
    
    private var datasOrdenadas: [Date] {
        return tarefasConcluidasAgrupadas.keys.sorted(by: >)
    }

    var body: some View {
        ZStack {
            Color.corFundo
                .ignoresSafeArea()
            
            VStack(alignment: .leading, spacing: 24) {
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
        .sheet(isPresented: $showModal_add) { TarefaAddModalView().presentationDetents([.large]) }
        .sheet(isPresented: $showModal) {
            if let id = tarefa_id_edicao { TelaEditModalView(id: id).presentationDetents([.large]) }
        }
        .sheet(isPresented: $mostrandoTelaPerfil) { PerfilView() }
        .sheet(isPresented: $mostrandoTelaAlterarModo) { AlterarModoView() }
        .onChange(of: showModal_aux) {
            if showModal_aux { showModal = true }
        }
        .onChange(of: showModal) {
            if !showModal {
                showModal_aux = false
                tarefa_id_edicao = nil
            }
        }
        .alert("Atenção", isPresented: $mostrandoAlertaLimpar) {
            Button("Apagar Tudo", role: .destructive) { tarefaModel.limparTarefasConcluidas() }
            Button("Cancelar", role: .cancel) { }
        } message: {
            Text("Isso apagará seu histórico de tarefas concluídas e pode afetar a precisão da priorização futura. Deseja continuar?")
        }
        .onAppear {
            tarefaModel.verificarEGerarPlanoDoDia()
        }
    }
    
    private var cabecalhoView: some View {
        HStack(spacing: 8) {
            VStack(alignment: .leading, spacing: 5) {
                Text("Olá \(userModel.user.nome),")
                    .font(.body).fontWeight(.semibold).foregroundColor(.corTextoSecundario)
                Text(textoModo)
                    .font(.system(size: 22)).fontWeight(.semibold).foregroundColor(corModo)
                Button("Clique aqui para alterar") { mostrandoTelaAlterarModo = true }
                    .font(.system(size: 13)).fontWeight(.regular).foregroundColor(.corTextoTerciario)
            }
            Spacer()
            Button(action: { mostrandoTelaPerfil = true }) {
                Image(systemName: "person")
                    .foregroundColor(.corPrimaria).font(.system(size: 30)).bold()
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
        List {
            if tarefasFiltradas.isEmpty && filtro == "Para hoje" {
                Text("O seu plano do dia está vazio! Adicione novas tarefas.")
                    .foregroundColor(.corTextoSecundario)
                    .multilineTextAlignment(.center)
                    .padding(.top, 40)
                    // --- CORREÇÃO ADICIONADA ---
                    .listRowBackground(Color.corFundo)
                    .listRowSeparator(.hidden)
            } else if tarefasFiltradas.isEmpty && filtro == "Todas" {
                Text("Você não tem nenhuma tarefa pendente. Aproveite o descanso!")
                    .foregroundColor(.corTextoSecundario)
                    .multilineTextAlignment(.center)
                    .padding(.top, 40)
                    // --- CORREÇÃO ADICIONADA ---
                    .listRowBackground(Color.corFundo)
                    .listRowSeparator(.hidden)
            } else {
                ForEach(tarefasFiltradas) { tarefa in
                    CelulaDaTarefaView(
                        tarefa: tarefa,
                        tarefaExpandidaID: $id_tarefa_expandida,
                        tarefaParaEditar: $tarefa_id_edicao,
                        showEditModal: $showModal_aux
                    )
                    .listRowSeparator(.hidden)
                    .listRowInsets(EdgeInsets(top: 6, leading: 0, bottom: 6, trailing: 0))
                    .listRowBackground(Color.corFundo)
                }
            }
        }
        .listStyle(.plain)
        .scrollIndicators(.hidden)
    }
    
    private var listaDeConcluidasView: some View {
        List {
            if datasOrdenadas.isEmpty {
                Text("Nenhuma tarefa concluída ainda.")
                    .foregroundColor(.corTextoSecundario)
                    .frame(maxWidth: .infinity, alignment: .center)
                    .padding(.top, 40)
                    // --- CORREÇÃO ADICIONADA ---
                    .listRowBackground(Color.corFundo)
                    .listRowSeparator(.hidden)
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
                            .listRowSeparator(.hidden)
                            .listRowInsets(EdgeInsets(top: 6, leading: 0, bottom: 6, trailing: 0))
                            .listRowBackground(Color.corFundo)
                        }
                    } header: {
                        HStack {
                            Text(data, style: .date)
                                .font(.headline).foregroundColor(.corTextoSecundario)
                            Spacer()
                            Button("Limpar") { mostrandoAlertaLimpar = true }
                                .font(.caption).foregroundColor(.red)
                        }
                    }
                }
            }
        }
        .listStyle(.plain)
        .scrollIndicators(.hidden)
    }
    
    private var botaoAdicionarView: some View {
        VStack {
            Spacer()
            HStack {
                Spacer()
                Button { showModal_add = true } label: {
                    Image(systemName: "plus.circle.fill")
                        .foregroundColor(.corPrimaria).font(.system(size: 45))
                }
                .padding([.horizontal, .bottom], 20)
            }
        }
    }
    
    private var indicadorDeProgressoView: some View {
        VStack {
            ProgressView().scaleEffect(1.5)
            Text("Priorizando tarefas...").padding(.top, 8)
        }
        .padding(20).background(.thinMaterial).cornerRadius(10)
    }
}

#Preview {
    TelaInicialView()
}
