import SwiftUI

struct TelaInicialView: View {
    @ObservedObject var tarefaModel = TarefaModel.shared

    @ObservedObject var userModel = UserModel.shared

    @State private var filtro: String = "Todos"
    @State private var showModal = false
    @State private var showModal_aux = false
    @State private var tarefa_id_edicao : UUID = UUID()
    @State private var id_tarefa_expandida : UUID = UUID()
    @State private var decidir_modo = false
    @State private var expandir = false
    
    var cor: Color {
            switch userModel.user.modo_selecionado {
            case 1: return .green
            case 2: return .orange
            case 3: return .red
            default: return .gray
            }
        }

    private var tarefasFiltradas: [Tarefa] {
        if filtro == "Todos" {
            return tarefaModel.tarefas.filter { !$0.concluida }
        }
        
        let prioridadeFiltro: Int
        switch filtro {
            case "Alta": prioridadeFiltro = 1
            case "Média": prioridadeFiltro = 2
            case "Baixa": prioridadeFiltro = 3
            default: return [] // Caso inesperado
        }
        
        return tarefaModel.tarefas.filter { !$0.concluida && $0.prioridade == prioridadeFiltro }
    }
    
    private var tarefasConcluidas: [Tarefa] {
        let hoje = Calendar.current.startOfDay(for: Date())

        return tarefaModel.tarefas.filter {
            $0.concluida && ($0.data_conclusao ?? Date.distantFuture) >= hoje
        }
    }
    
        
    
    var body: some View {
        ZStack {
            VStack(spacing: 24) {
                VStack(alignment: .leading, spacing: 16) {
                    HStack {
                        Text("Visualize suas atividades")
                            .font(.title)
                            .bold()
                        Spacer()
                    }
                    
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack(spacing: 12) {
                            BotaoFiltro(titulo: "Todos", filtroSelecionado: $filtro)
                            BotaoFiltro(titulo: "Alta", filtroSelecionado: $filtro)
                            BotaoFiltro(titulo: "Média", filtroSelecionado: $filtro)
                            BotaoFiltro(titulo: "Baixa", filtroSelecionado: $filtro)
                        }
                    }
                }
                .padding(.horizontal, 24)
                .padding(.top, 24)
                
                //para teste
                HStack{
                    Spacer()
                    Circle()
                        .frame(width: 50, height: 50)
                    // Tamanho
                        .foregroundColor(cor)
                    // Cor de preenchimento
                    Spacer()
                    VStack(alignment:.leading){
                        Text("Modo selecionado : \(userModel.user.modo_selecionado)")
                        Button{
                            decidir_modo.toggle()
                        }label:{
                            Text("Alterar")
                        }
                        
                        if(decidir_modo){
                            HStack{
                                Button{
                                    userModel.atualizar_modo(modo: 0)
                                    decidir_modo.toggle()
                                    print(userModel.user.modo_selecionado)
                                }label:{
                                    Circle()
                                        .frame(width: 20, height: 20)
                                    // Tamanho
                                        .foregroundColor(.gray)
                                    // Cor de preenchimento
                                }
                                
                                Button{
                                    userModel.atualizar_modo(modo: 1)
                                    decidir_modo.toggle()
                                    print(userModel.user.modo_selecionado)
                                }label:{
                                    Circle()
                                        .frame(width: 20, height: 20)
                                    // Tamanho
                                        .foregroundColor(.green)
                                    // Cor de preenchimento
                                }
                                Button{
                                    userModel.atualizar_modo(modo: 2)
                                    decidir_modo.toggle()
                                    print(userModel.user.modo_selecionado)
                                }label:{
                                    Circle()
                                        .frame(width: 20, height: 20)
                                    // Tamanho
                                        .foregroundColor(.orange)
                                    // Cor de preenchimento
                                }
                                Button{
                                    userModel.atualizar_modo(modo: 3)
                                    decidir_modo.toggle()
                                    print(userModel.user.modo_selecionado)
                                }label:{
                                    Circle()
                                        .frame(width: 20, height: 20)
                                    // Tamanho
                                        .foregroundColor(.red)
                                    // Cor de preenchimento
                                }
                            }
                        }
                    }
                    Spacer()
                }
                //para teste
                
                List {
                    Section(header: Text(filtro == "Todos" ? "Todas as Prioridades" : "Prioridade \(filtro)")) {
                        if tarefasFiltradas.isEmpty && !tarefaModel.estaPriorizando {
                             Text("Nenhuma tarefa com esta prioridade.")
                                .foregroundColor(.secondary)
                        } else {
                            ForEach(tarefasFiltradas) { tarefa in
                                celulaDaTarefa(tarefa: tarefa)
                            }
                        }
                    }
                    
                    if !tarefasConcluidas.isEmpty {
                        Section(header: Text("Concluídas")) {
                            ForEach(tarefasConcluidas) { tarefa in
                                celulaDaTarefa(tarefa: tarefa)
                            }
                        }
                    }
                }
                .listStyle(.plain)
                .scrollContentBackground(.hidden)
            }
            
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
        }   .sheet(isPresented: $showModal) {
            TelaEditModalView(id:tarefa_id_edicao)
                .presentationDetents([.large])
        }
        .onChange(of: showModal_aux) {
            if showModal_aux {
                showModal = true
            }
        }
        .onChange(of: showModal) {
            if showModal {
                showModal_aux = false
            }
        }
    }
    
    @ViewBuilder
    private func celulaDaTarefa(tarefa: Tarefa) -> some View {
        HStack(spacing: 15) {
            Button(action: {
                tarefaModel.marcarTarefa(tarefa: tarefa)
                //para fechar automatico quando expandida
                if(id_tarefa_expandida == tarefa.id && expandir){
                    expandir=false
                }
            }) {
                Image(systemName: tarefa.concluida ? "checkmark.circle.fill" : "circle")
                    .font(.title2).foregroundColor(tarefa.concluida ? .green : .secondary)
            }.buttonStyle(.plain)
            VStack(alignment: .leading, spacing: 5) {
                Text(tarefa.nome).font(.headline).strikethrough(tarefa.concluida, color: .primary)
                if let descricao = tarefa.descricao, !descricao.isEmpty {
                    Text(descricao).font(.subheadline).lineLimit(2).foregroundColor(.secondary)
                }
                if(id_tarefa_expandida != tarefa.id || expandir == false){
                    HStack {
                        HStack(spacing: 4) { Image(systemName: "hourglass"); Text("\(tarefa.duracao_minutos) min") }
                        Spacer()
                        HStack(spacing: 4) { Image(systemName: "bolt.fill"); Text(tarefa.importancia) }
                        
                    }.font(.caption).foregroundColor(.secondary).padding(.top, 4)
                }
                
                if (id_tarefa_expandida == tarefa.id && expandir == true){
                    Text("Dificuldade : \(tarefa.dificuldade)")
                    .font(.subheadline).foregroundColor(.secondary).padding(.top, 4)
                    Text("Esforço : \(tarefa.esforco)")
                    .font(.subheadline).foregroundColor(.secondary).padding(.top, 4)
                    Text("Importância : \(tarefa.importancia)")
                    .font(.subheadline).foregroundColor(.secondary).padding(.top, 4)
                    let tempo = String(format: "%dh %02dmin", tarefa.duracao_minutos / 60, tarefa.duracao_minutos % 60)
                    Text("Duração : \(tempo)")
                    .font(.subheadline).foregroundColor(.secondary).padding(.top, 4)
                }
            }
            Spacer()
            if !tarefa.concluida {
                Text("\(tarefa.prioridade ?? 0)").font(.caption).fontWeight(.bold).padding(8).background(corDaPrioridade(tarefa.prioridade)).foregroundColor(.white).clipShape(Circle())
            }
        }.padding(.vertical, 5).opacity(tarefa.concluida ? 0.6 : 1.0)
        .swipeActions {
            Button(){
                tarefaModel.deletar_tarefa(id: tarefa.id)
            } label: {
                Label("Excluir", systemImage: "trash")
            }
            .tint(.red)
            
            Button(){
                tarefa_id_edicao = tarefa.id
                showModal_aux = true
            } label: {
                Label("Editar", systemImage: "pencil")
            }
            .tint(.blue)
        }
        .onTapGesture {
            id_tarefa_expandida=tarefa.id
            expandir.toggle()
        }
    }
    
    private func corDaPrioridade(_ prioridade: Int?) -> Color {
        switch prioridade {
        case 1: return .red
        case 2: return .orange
        case 3: return .blue
        default: return .gray
        }
    }
}

struct BotaoFiltro: View {
    let titulo: String
    @Binding var filtroSelecionado: String
    
    var isSelected: Bool {
        titulo == filtroSelecionado
    }
    
    var body: some View {
        Button(action: {
            filtroSelecionado = titulo
        }) {
            Text(titulo)
                .fontWeight(isSelected ? .bold : .regular)
                .foregroundColor(isSelected ? .white : .blue)
                .padding(.horizontal, 24)
                .padding(.vertical, 8)
                .background(
                    Capsule().fill(isSelected ? Color.blue : Color.clear)
                )
                .overlay(
                    Capsule().stroke(Color.blue.opacity(0.5))
                )
        }
    }
}

#Preview {
    TelaInicialView()
}
