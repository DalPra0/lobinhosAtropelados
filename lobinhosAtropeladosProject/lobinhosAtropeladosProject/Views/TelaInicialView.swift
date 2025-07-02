import SwiftUI

struct TelaInicialView: View {
    @ObservedObject var tarefaModel = TarefaModel.shared
    @ObservedObject var ritmoManager: RitmoDiaManager
    
    @State private var filtro: String = "Priorizadas"
    @State private var showEditModal = false
    @State private var tarefaParaEditar: UUID?
    @State private var tarefaExpandidaID: UUID? = nil

    // MARK: - Propriedades Computadas (Lógica da View)

    private var tarefasAtivas: [Tarefa] {
        tarefaModel.tarefas.filter { !$0.concluida }
    }
    
    private var tarefasConcluidas: [Tarefa] {
        tarefaModel.tarefas.filter { $0.concluida }
    }
    
    private var planoDoDia: [Tarefa] {
        guard ritmoManager.ritmoAtual != .nenhum, ritmoManager.tempoDisponivelEmMinutos > 0 else {
            return []
        }
        
        var plano: [Tarefa] = []
        var tempoAcumulado = 0
        
        for tarefa in tarefasAtivas.sorted() {
            if (tempoAcumulado + tarefa.duracao_minutos) <= ritmoManager.tempoDisponivelEmMinutos {
                plano.append(tarefa)
                tempoAcumulado += tarefa.duracao_minutos
            }
        }
        return plano
    }
    
    private var tarefasParaExibir: [Tarefa] {
        if filtro == "Todas" {
            return tarefasAtivas.sorted()
        }
        
        if ritmoManager.ritmoAtual == .nenhum {
            return tarefasAtivas.sorted()
        } else {
            return planoDoDia
        }
    }

    // MARK: - Corpo da View Principal
    
    var body: some View {
        ZStack {
            Color("corFundo").ignoresSafeArea()
            
            VStack(spacing: 16) {
                cabecalhoView
                RitmoCardView(ritmoManager: ritmoManager)
                FiltroTarefasView(filtro: $filtro, contagemPriorizadas: planoDoDia.count, contagemTodas: tarefasAtivas.count)
                
                listaDeTarefasView
            }
            
            if tarefaModel.estaPriorizando {
                indicadorDeAtividadeView
            }
        }
        .sheet(isPresented: $showEditModal) {
            if let id = tarefaParaEditar {
                TelaEditModalView(id: id)
            }
        }
    }
    
    // MARK: - Componentes da View
    
    private var cabecalhoView: some View {
        HStack {
            VStack(alignment: .leading) {
                Text("Olá, Ana!")
                    .font(.secularOne(size: 32))
                Text("Hoje é \(Date().formatted(.dateTime.weekday(.wide).day().month(.wide)))")
                    .font(.callout)
                    .foregroundColor(Color("corTextoSecundario"))
            }
            Spacer()
        }
        .padding(.horizontal, 24).padding(.top, 16).foregroundColor(Color("corTextoPrimario"))
    }
    
    // CORREÇÃO APLICADA AQUI
    private var listaDeTarefasView: some View {
        List {
            // --- SEÇÃO DE TAREFAS ATIVAS ---
            Section(header: Text(filtro).font(.secularOne(size: 18)).foregroundColor(Color("corTextoPrimario")).textCase(nil)) {
                if tarefasParaExibir.isEmpty && !tarefaModel.estaPriorizando {
                    mensagemVaziaView(texto: "Nenhuma tarefa para hoje neste filtro.")
                } else {
                    ForEach(tarefasParaExibir) { tarefa in
                        CelulaDaTarefa(tarefa: tarefa, tarefaExpandidaID: $tarefaExpandidaID, tarefaParaEditar: $tarefaParaEditar, showEditModal: $showEditModal)
                    }
                }
            }
            .listRowBackground(Color.clear)
            .listRowSeparator(.hidden)
            
            // --- SEÇÃO DE TAREFAS CONCLUÍDAS ---
            // Esta seção agora é sempre renderizada, e o ForEach dentro dela
            // cuida de mostrar ou não as tarefas. Isso corrige o bug.
            if !tarefasConcluidas.isEmpty {
                Section(header: Text("Concluídas").font(.secularOne(size: 18)).foregroundColor(Color("corTextoPrimario")).textCase(nil)) {
                    ForEach(tarefasConcluidas) { tarefa in
                        CelulaDaTarefa(tarefa: tarefa, tarefaExpandidaID: .constant(nil), tarefaParaEditar: .constant(nil), showEditModal: .constant(false))
                    }
                }
                .listRowBackground(Color.clear)
                .listRowSeparator(.hidden)
            }
        }
        .listStyle(.plain)
        .scrollContentBackground(.hidden) // Garante que o fundo da lista seja transparente
    }
    
    private func mensagemVaziaView(texto: String) -> some View {
        HStack {
            Spacer()
            Text(texto)
                .font(.secularOne(size: 16))
                .foregroundColor(Color("corTextoSecundario"))
                .multilineTextAlignment(.center)
                .padding(.vertical, 40)
            Spacer()
        }
        .listRowBackground(Color.clear)
    }
    
    private var indicadorDeAtividadeView: some View {
        VStack {
            ProgressView().scaleEffect(1.5).tint(.white)
            Text("Priorizando tarefas...").font(.secularOne(size: 16)).padding(.top, 8)
        }
        .padding(24).background(.ultraThinMaterial).cornerRadius(16).foregroundColor(Color("corTextoPrimario"))
    }
}


// MARK: - Componentes Auxiliares (O código aqui permanece o mesmo da última versão)

struct RitmoCardView: View {
    @ObservedObject var ritmoManager: RitmoDiaManager
    
    var body: some View {
        Button(action: { ritmoManager.mostrarTelaDeRitmo = true }) {
            HStack(spacing: 16) {
                mascoteView.frame(width: 44, height: 44)
                VStack(alignment: .leading) {
                    Text(textoPrincipal).font(.secularOne(size: 18))
                    Text("Clique aqui para alterar").font(.caption).foregroundColor(Color("corTextoSecundario"))
                }
                Spacer()
            }
            .padding(EdgeInsets(top: 12, leading: 16, bottom: 12, trailing: 16))
            .background(Color("corCardSecundario").opacity(0.5))
            .cornerRadius(16)
            .foregroundColor(Color("corTextoPrimario"))
        }
        .padding(.horizontal, 24)
    }
    
    @ViewBuilder
    private var mascoteView: some View {
        switch ritmoManager.ritmoAtual {
        case .tranquilo: Image("gimoMascoteTranquilo").resizable().scaledToFit()
        case .moderado: Image("gimoMascoteModerado").resizable().scaledToFit()
        case .intenso: Image("gimoMascoteIntenso").resizable().scaledToFit()
        case .nenhum:
            Circle().fill(Color.gray.opacity(0.3)).overlay(Image(systemName: "sparkles").foregroundColor(Color("corTextoPrimario").opacity(0.8)))
        }
    }
    
    private var textoPrincipal: String {
        switch ritmoManager.ritmoAtual {
        case .tranquilo: return "Seu dia será tranquilo!"
        case .moderado: return "Seu dia será moderado!"
        case .intenso: return "Seu dia será intenso!"
        case .nenhum: return "Defina o ritmo do seu dia"
        }
    }
}

struct FiltroTarefasView: View {
    @Binding var filtro: String
    let contagemPriorizadas: Int
    let contagemTodas: Int
    
    var body: some View {
        HStack(spacing: 12) {
            BotaoFiltro(titulo: "Priorizadas", contagem: contagemPriorizadas, filtroSelecionado: $filtro)
            BotaoFiltro(titulo: "Todas", contagem: contagemTodas, filtroSelecionado: $filtro)
            Spacer()
        }
        .padding(.horizontal, 24)
    }
}

struct BotaoFiltro: View {
    let titulo: String
    let contagem: Int
    @Binding var filtroSelecionado: String
    
    var isSelected: Bool { titulo == filtroSelecionado }
    
    var body: some View {
        Button(action: { filtroSelecionado = titulo }) {
            HStack(spacing: 4) {
                Text(titulo)
                Text("(\(contagem))").foregroundColor(isSelected ? Color("corTextoPrimario").opacity(0.7) : Color("corTextoSecundario"))
            }
            .font(.secularOne(size: 14))
            .foregroundColor(isSelected ? Color("corTextoPrimario") : Color("corTextoSecundario"))
            .padding(.horizontal, 20).padding(.vertical, 10)
            .background(Capsule().fill(isSelected ? Color("corBotaoFiltro") : Color("corCardSecundario").opacity(0.5)))
        }
    }
}

struct CelulaDaTarefa: View {
    let tarefa: Tarefa
    @Binding var tarefaExpandidaID: UUID?
    @Binding var tarefaParaEditar: UUID?
    @Binding var showEditModal: Bool
    
    @ObservedObject var tarefaModel = TarefaModel.shared
    
    private var isExpanded: Bool {
        tarefaExpandidaID == tarefa.id
    }
    
    var body: some View {
        VStack(spacing: 0) {
            HStack(spacing: 16) {
                Button(action: { tarefaModel.marcarTarefa(tarefa: tarefa) }) {
                    Image(systemName: tarefa.concluida ? "checkmark.circle.fill" : "circle")
                        .font(.title2).foregroundColor(tarefa.concluida ? Color("corDestaqueBaixa") : Color("corTextoSecundario"))
                }.buttonStyle(.plain)
                
                Text(tarefa.nome).font(.body).strikethrough(tarefa.concluida)
                Spacer()
                
                if !tarefa.concluida {
                    if let prioridade = tarefa.prioridade {
                        Text(textoDaPrioridade(prioridade)).font(.caption.bold()).foregroundColor(corDaPrioridade(prioridade))
                    }
                    Image(systemName: "chevron.down").font(.caption.bold()).foregroundColor(Color("corTextoSecundario")).rotationEffect(.degrees(isExpanded ? 180 : 0))
                }
            }
            .padding()
            .contentShape(Rectangle())
            .onTapGesture {
                guard !tarefa.concluida else { return }
                withAnimation(.spring(response: 0.4, dampingFraction: 0.8)) {
                    tarefaExpandidaID = isExpanded ? nil : tarefa.id
                }
            }
            
            if isExpanded {
                VStack(alignment: .leading, spacing: 12) {
                    Divider().background(Color.gray.opacity(0.3))
                    if let descricao = tarefa.descricao, !descricao.isEmpty {
                        Text(descricao).font(.callout).foregroundColor(Color.black.opacity(0.7))
                    }
                    HStack {
                        detalheItem(titulo: "Duração", valor: "\(tarefa.duracao_minutos) min")
                        Spacer()
                        detalheItem(titulo: "Dificuldade", valor: tarefa.dificuldade)
                    }
                    HStack {
                        detalheItem(titulo: "Esforço", valor: tarefa.esforco)
                        Spacer()
                        detalheItem(titulo: "Importância", valor: tarefa.importancia)
                    }
                }
                .padding([.horizontal, .bottom])
                .transition(.asymmetric(insertion: .opacity.combined(with: .move(edge: .top)), removal: .opacity))
            }
        }
        .background(Color("corCardPrincipal"))
        .cornerRadius(16)
        .foregroundColor(tarefa.concluida ? Color("corTextoSecundario") : .black)
        .swipeActions {
            if !tarefa.concluida {
                Button(role: .destructive, action: { tarefaModel.deletar_tarefa(id: tarefa.id) }) {
                    Label("Excluir", systemImage: "trash")
                }
                Button(action: {
                    tarefaParaEditar = tarefa.id
                    showEditModal = true
                }) {
                    Label("Editar", systemImage: "pencil")
                }.tint(.blue)
            }
        }
    }
    
    private func detalheItem(titulo: String, valor: String) -> some View {
        VStack(alignment: .leading) {
            Text(titulo).font(.caption.bold()).foregroundColor(.black.opacity(0.6))
            Text(valor).font(.body)
        }
    }
    
    private func textoDaPrioridade(_ p: Int) -> String {
        switch p {
        case 1: return "Alta"
        case 2: return "Média"
        case 3: return "Baixa"
        default: return "Definir"
        }
    }
    
    private func corDaPrioridade(_ p: Int?) -> Color {
        switch p {
        case 1: return Color("corDestaqueAlta")
        case 2: return Color("corDestaqueMedia")
        case 3: return Color("corDestaqueBaixa")
        default: return .gray
        }
    }
}
