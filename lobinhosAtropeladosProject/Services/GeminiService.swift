import Foundation
import GoogleGenerativeAI

class GeminiService {
    
    private var generativeModel: GenerativeModel
    
    init() {
        let config = GenerationConfig(responseMIMEType: "application/json")
        self.generativeModel = GenerativeModel(name: "gemini-1.5-flash", apiKey: APIKeyManager.geminiKey, generationConfig: config)
    }
    
    func gerarPlanoDiario(
        tarefasPendentes: [Tarefa],
        tarefasConcluidas: [Tarefa],
        perfilUsuario: User
    ) async throws -> (planoDoDia: [Tarefa], naoPlanejado: [Tarefa]) {
        
        guard !tarefasPendentes.isEmpty else {
            return (planoDoDia: [], naoPlanejado: [])
        }
        
        var modoProdutividadeTexto = "Moderado"
        var orcamentoTempoMinutos = 300

        switch perfilUsuario.modo_selecionado {
        case 1:
            modoProdutividadeTexto = "Tranquilo"
            orcamentoTempoMinutos = 180
        case 3:
            modoProdutividadeTexto = "Intenso"
            orcamentoTempoMinutos = 420
        default:
            break
        }
        
        let prompt = """
        Você é um Estrategista de Produtividade Acadêmica de Elite. Sua única missão é analisar o estado atual das tarefas de um estudante e montar o plano de estudos diário mais otimizado possível, respeitando um orçamento de tempo.

        **INFORMAÇÕES DISPONÍVEIS:**
        - Perfil do Estudante: Cursa \(perfilUsuario.curso) (\(perfilUsuario.periodo)).
        - Modo de Produtividade do Dia: "\(modoProdutividadeTexto)".
        - Tarefas Pendentes: A lista COMPLETA de todas as tarefas que o usuário ainda não concluiu.
        - Histórico de Conclusão: Tarefas que o estudante já completou. Use para entender o comportamento e a velocidade do usuário.

        **SEU PROCESSO DE ANÁLISE (A SER SEGUIDO RIGOROSAMENTE):**

        **Passo 1: PRIORIZAR E ESTIMAR DURAÇÃO DE TODAS AS TAREFAS PENDENTES.**
        Sua primeira tarefa é analisar a lista de "Tarefas Pendentes" e, para CADA UMA delas, adicionar dois campos: `prioridade` e `duracaoEstimadaMinutos`.
        1.  **Atribuir Prioridade:** Crie o campo `prioridade` (1 = mais alta, 2, 3, etc.) usando as seguintes regras em ordem:
            -   **Prazo de Entrega:** Tarefas com prazo mais próximo são mais importantes.
            -   **Análise Comportamental:** Use o "Histórico de Conclusão" para identificar padrões. Se o usuário costuma deixar tarefas de um certo tipo para a última hora, aumente sutilmente a prioridade de tarefas similares.
            -   **Dificuldade:** Use como critério de desempate.
        2.  **Estimar Duração:** Crie o campo `duracaoEstimadaMinutos` usando a `dificuldade` da tarefa como base. Siga esta tabela de conversão:
            -   Dificuldade "1": 30 minutos
            -   Dificuldade "2": 60 minutos
            -   Dificuldade "3": 90 minutos
            -   Dificuldade "4": 120 minutos
            -   Dificuldade "5": 180 minutos

        **Passo 2: MONTAR O PLANO DO DIA COM BASE NO ORÇAMENTO DE TEMPO.**
        Com a lista de tarefas agora priorizada e com durações estimadas, selecione as tarefas que farão parte do `"planoDoDia"`.
        -   O **orçamento de tempo** para hoje é de **\(orcamentoTempoMinutos) minutos**, baseado no Modo de Produtividade do estudante.
        -   Comece pela tarefa de `prioridade` 1 e vá adicionando as tarefas seguintes em ordem de prioridade.
        -   **Regra Crucial:** Continue adicionando tarefas enquanto a soma das `duracaoEstimadaMinutos` das tarefas selecionadas for **menor ou igual** ao orçamento de tempo. Se a próxima tarefa na lista de prioridades for fazer o tempo total ultrapassar o orçamento, **não a inclua**. O plano deve respeitar o limite de tempo.

        **FORMATO DA RESPOSTA:**
        Sua resposta DEVE ser um único objeto JSON com DUAS chaves:
        1.  `"planoDoDia"`: um array contendo as tarefas que você selecionou para o plano de hoje.
        2.  `"naoPlanejado"`: um array contendo TODAS as outras tarefas pendentes que não couberam no plano.
        
        É CRUCIAL que TODAS as tarefas pendentes originais estejam em um desses dois arrays e que TODAS tenham os campos `prioridade` e `duracaoEstimadaMinutos` preenchidos por você. Não inclua texto fora do objeto JSON.

        **DADOS PARA ANÁLISE:**
        - TAREFAS PENDENTES: \(tarefasPendentes.toJsonString())
        - HISTÓRICO DE CONCLUSÃO: \(tarefasConcluidas.toJsonString())
        """
        
        print("Enviando prompt de orçamento de tempo para o Gemini...")
        let response = try await generativeModel.generateContent(prompt)
        
        guard let textResponse = response.text,
              let responseData = textResponse.data(using: .utf8) else {
            throw NSError(domain: "GeminiServiceError", code: 1, userInfo: [NSLocalizedDescriptionKey: "Resposta inválida do Gemini."])
        }
        
        struct GeminiResponse: Codable {
            let planoDoDia: [Tarefa]
            let naoPlanejado: [Tarefa]
        }
        
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .iso8601
        let decodedResponse = try decoder.decode(GeminiResponse.self, from: responseData)
        
        print("Plano diário baseado em tempo recebido e decodificado!")
        return (planoDoDia: decodedResponse.planoDoDia, naoPlanejado: decodedResponse.naoPlanejado)
    }
}

extension Array where Element == Tarefa {
    func toJsonString() -> String {
        let encoder = JSONEncoder()
        encoder.outputFormatting = .prettyPrinted
        encoder.dateEncodingStrategy = .iso8601
        if let data = try? encoder.encode(self), let jsonString = String(data: data, encoding: .utf8) {
            return jsonString
        }
        return "[]"
    }
}
