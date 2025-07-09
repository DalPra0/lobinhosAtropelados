import SwiftUI

struct TelaInicialView: View {
    @ObservedObject var tarefaModel = TarefaModel.shared
    @ObservedObject var userModel = UserModel.shared
    
    // Estados para os modais e alertas
    @State private var showModal_add = false
    @State private var showModal = false
    @State private var showModal_aux = false
    @State private var tarefa_id_edicao: UUID? = nil
    @State private var id_tarefa_expandida: UUID? = nil
    @State private var mostrandoAlertaLimpar = false
    @State private var mostrandoTelaPerfil = false
    @State private var mostrandoTelaAlterarModo = false
    
    // Variável de estado para o filtro
    @State private var filtro: String = "Para hoje"
    
    // Estados para o alerta de exportação
    @State private var mostrandoAlertaCalendario = false
    @State private var tituloAlertaCalendario = ""
    @State private var mensagemAlertaCalendario = ""

    
    private var textoModo: String {
        switch userModel.user.modo_selecionado {
        case 1: return "Seu dia será tranquilo!"
        case 2: return "Seu dia será moderado!"
        case 3: return "Seu dia será intenso!"
        default: return "Defina seu ritmo de hoje!"
        }
    }
    
    private var mascote: String {
        switch userModel.user.modo_selecionado {
        case 1: return "gimoMascoteVerde"
        case 2: return "gimoMascoteAmarelo"
        case 3: return "gimoMascoteLaranja"
        default: return "gimoMascoteNeutro"
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
            
            VStack(alignment: .leading, spacing: 32) {
                cabecalhoView
                
                VStack(alignment: .leading){
                    VStack(alignment: .leading, spacing: 14) {
                        HStack {
                            Text("Minhas tarefas")
                                .bold()
                                .font(.system(size: 25))
                            Spacer()
                            // Botão de exportar
                            Button(action: exportarTarefas) {
                                Image(systemName: "calendar.badge.plus")
                                    .font(.title2)
                                    .foregroundColor(Color("corPrimaria"))
                            }
                        }
                        
                        filtrosView
                    }
                        
                        if filtro == "Concluídas" {
                            listaDeConcluidasView
                        } else {
                            listaDePendentesView
                        }
                    
                }
                    
            }
            .padding(.horizontal, 24)
            .padding(.top, 60)
            //fix de posicao
            .ignoresSafeArea()
            
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
        .onChange(of: showModal_aux) { if $1 { showModal = true } }
        .onChange(of: showModal) { if !$1 { showModal_aux = false; tarefa_id_edicao = nil } }
        .alert("Atenção", isPresented: $mostrandoAlertaLimpar) {
            Button("Apagar Tudo", role: .destructive) { tarefaModel.limparTarefasConcluidas() }
            Button("Cancelar", role: .cancel) { }
        } message: {
            Text("Isso apagará seu histórico de tarefas concluídas e pode afetar a precisão da priorização futura. Deseja continuar?")
        }
        // Alerta de calendário
        .alert(tituloAlertaCalendario, isPresented: $mostrandoAlertaCalendario) {
            Button("OK", role: .cancel) { }
        } message: {
            Text(mensagemAlertaCalendario)
        }
        .onAppear {
            tarefaModel.verificarEGerarPlanoDoDia()
        }
        // Manipulador de URL para o widget
        .onOpenURL { url in
            if url.scheme == "gimo" && url.host == "addTask" {
                showModal_add = true
            }
        }
    }
    
    private func exportarTarefas() {
        tarefaModel.exportarTarefasParaCalendario { result in
            switch result {
            case .success(let count):
                self.tituloAlertaCalendario = "Sucesso!"
                self.mensagemAlertaCalendario = "\(count) nova(s) tarefa(s) foi(ram) exportada(s) para o seu calendário."
            case .noTasksToExport:
                self.tituloAlertaCalendario = "Tudo Certo!"
                self.mensagemAlertaCalendario = "Todas as suas tarefas pendentes já estão no seu calendário."
            case .permissionDenied:
                self.tituloAlertaCalendario = "Acesso Negado"
                self.mensagemAlertaCalendario = "Para exportar, por favor, autorize o acesso ao Calendário nas Ajustes do seu iPhone."
            case .failure(let error):
                self.tituloAlertaCalendario = "Erro"
                self.mensagemAlertaCalendario = "Ocorreu um erro ao exportar: \(error.localizedDescription)"
            }
            self.mostrandoAlertaCalendario = true
        }
    }
    
    private var cabecalhoView: some View {
        
        VStack(alignment: .leading, spacing: 18) {
            
            HStack {
                Spacer()
                Button(action: { mostrandoTelaPerfil = true }) {
                    ZStack{
                        Image(systemName: "person")
                            .foregroundColor(.corPrimaria).font(.system(size: 18))
                        
                        
                        Circle()
                            .stroke(Color.corPrimaria, lineWidth: 1) // Borda do círculo
                            .frame(width: 32, height: 32) // Tamanho do círculo
                        
                    }
                }
            }
            
            HStack(spacing: 16) {
                
                Image(mascote)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 57, height: 55)
                
                VStack(alignment: .leading, spacing: 4) {
                    Text(textoModo)
                        .font(.system(size: 22)).fontWeight(.semibold).foregroundColor(corModo)
                    Button("Editar") { mostrandoTelaAlterarModo = true }
                        .font(.system(size: 13)).fontWeight(.medium).foregroundColor(.corTextoTerciario)
                }
                Spacer()
            }
        }
    }
    
    private var filtrosView: some View {
        VStack(alignment: .leading, spacing: 10){
            HStack(spacing: 8) {
                BotaoFiltro(titulo: "Para hoje", filtroSelecionado: $filtro)
                BotaoFiltro(titulo: "Concluídas", filtroSelecionado: $filtro)
                BotaoFiltro(titulo: "Todas", filtroSelecionado: $filtro)
            }
            //label
            if filtro == "Para hoje"{
                Text("As suas tarefas priorizadas serão exibidas aqui")
                    .font(.footnote)
                    .foregroundColor(.corLabelIncial)
            }else if filtro == "Concluídas"{
                Text("As suas tarefas concluídas serão exibidas aqui")
                    .font(.footnote)
                    .foregroundColor(.corLabelIncial)
            }else{
                Text("Aqui você verá todas as tarefas que não foram concluídas")
                    .font(.footnote)
                    .foregroundColor(.corLabelIncial)
            }
        }
    }
    
    private var listaDePendentesView: some View {
        List {
            if tarefasFiltradas.isEmpty {
                Text(filtro == "Para hoje" ? "O seu plano do dia está vazio! Adicione novas tarefas." : "Você não tem nenhuma tarefa pendente. Aproveite o descanso!")
                    .foregroundColor(.corTextoSecundario)
                    .multilineTextAlignment(.center)
                    .padding(.top, 40)
                    .listRowBackground(Color.corFundo)
                    .listRowSeparator(.hidden)
            } else {
                ForEach(Array(tarefasFiltradas.enumerated()), id: \.element.id) { index, tarefa in
                    CelulaDaTarefaView(index:index+1,filtro:filtro,
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
                    .listRowBackground(Color.corFundo)
                    .listRowSeparator(.hidden)
            } else {
                ForEach(datasOrdenadas, id: \.self) { data in
                    Section {
                        ForEach(tarefasConcluidasAgrupadas[data] ?? []) { tarefa in
                            CelulaDaTarefaView(index:0,filtro:"Concluídas",
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
                                .environment(\.locale, Locale(identifier: "pt_BR"))
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
                ZStack{
                    Circle()
                        .frame(width:35, height: 35)
                        .foregroundColor(.white)
                    Button { showModal_add = true } label: {
                        Image(systemName: "plus.circle.fill")
                            .foregroundColor(.corPrimaria).font(.system(size: 45))
                    }

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
