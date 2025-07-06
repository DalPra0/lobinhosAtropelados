import Foundation
import GoogleGenerativeAI

class GeminiService {
    
    private var generativeModel: GenerativeModel
    
    init() {
        let config = GenerationConfig(responseMIMEType: "application/json")
        self.generativeModel = GenerativeModel(name: "gemini-1.5-flash", apiKey: APIKeyManager.geminiKey, generationConfig: config)
    }
    
    // A função agora recebe apenas as tarefas pendentes e concluídas.
    // A IA sempre tentará criar o melhor plano possível com os dados fornecidos.
    func gerarPlanoDiario(
        tarefasPendentes: [Tarefa],
        tarefasConcluidas: [Tarefa],
        perfilUsuario: User
    ) async throws -> (planoDoDia: [Tarefa], naoPlanejado: [Tarefa]) {
        
        guard !tarefasPendentes.isEmpty else {
            return (planoDoDia: [], naoPlanejado: [])
        }
        
        // --- PROMPT FINAL E SIMPLIFICADO ---
        let prompt = """
        Você é um Estrategista de Produtividade Acadêmica de Elite. Sua única missão é analisar o estado atual das tarefas de um estudante e montar o plano de estudos diário mais otimizado possível.

        **INFORMAÇÕES DISPONÍVEIS:**
        - Perfil do Estudante: Cursa \(perfilUsuario.curso) (\(perfilUsuario.periodo)).
        - Estilo de Organização Preferido: "\(perfilUsuario.estiloOrganizacao ?? "Não definido")". Este é o fator que define o TAMANHO do plano do dia.
        - Tarefas Pendentes: A lista COMPLETA de todas as tarefas que o usuário ainda não concluiu.
        - Histórico de Conclusão: Tarefas que o estudante já completou. Use para entender o comportamento e a velocidade do usuário.

        **SEU PROCESSO DE ANÁLISE (A SER SEGUIDO RIGOROSAMENTE):**

        **Passo 1: PRIORIZAR TODAS AS TAREFAS PENDENTES.**
        Sua primeira tarefa é analisar a lista de "Tarefas Pendentes" e atribuir uma `prioridade` numérica (1 = mais alta, 2, 3, etc.) para CADA UMA delas. Use as seguintes regras em ordem:
        1.  **Prazo de Entrega:** Tarefas com prazo mais próximo são mais importantes.
        2.  **Análise Comportamental:** Use o "Histórico de Conclusão" para identificar padrões. Se o usuário costuma deixar tarefas de um certo tipo para a última hora, aumente sutilmente a prioridade de tarefas similares.
        3.  **Dificuldade:** Use como critério de desempate.

        **Passo 2: MONTAR O PLANO DO DIA.**
        Com a lista de tarefas agora priorizada, selecione as tarefas que farão parte do "planoDoDia". A quantidade de tarefas a serem selecionadas depende DIRETAMENTE do `Estilo de Organização` do usuário:
        - Se o estilo for "Poucas tarefas e um dia tranquilo.": Selecione exatamente as **2 tarefas** de maior prioridade.
        - Se o estilo for "Algumas tarefas..." ou "Ser produtivo...": Selecione exatamente as **4 tarefas** de maior prioridade.
        - Se o estilo for "Foco total...": Selecione exatamente as **6 tarefas** de maior prioridade.

        **FORMATO DA RESPOSTA:**
        Sua resposta DEVE ser um único objeto JSON com DUAS chaves:
        1.  `"planoDoDia"`: um array contendo as tarefas que você selecionou para o plano de hoje.
        2.  `"naoPlanejado"`: um array contendo TODAS as outras tarefas pendentes que não couberam no plano.
        
        É CRUCIAL que TODAS as tarefas pendentes originais estejam em um desses dois arrays e que TODAS tenham o campo `prioridade` preenchido por você. Não inclua texto fora do objeto JSON.

        **DADOS PARA ANÁLISE:**
        - TAREFAS PENDENTES: \(tarefasPendentes.toJsonString())
        - HISTÓRICO DE CONCLUSÃO: \(tarefasConcluidas.toJsonString())
        """
        
        print("Enviando prompt unificado para o Gemini...")
        let response = try await generativeModel.generateContent(prompt)
        
        guard let textResponse = response.text,
              let responseData = textResponse.data(using: .utf8) else {
            throw NSError(domain: "GeminiServiceError", code: 1, userInfo: [NSLocalizedDescriptionKey: "Resposta inválida do Gemini."])
        }
        
        struct GeminiResponse: Codable {
            let planoDoDia: [Tarefa]
            let naoPlanejado: [Tarefa]
        }
        
        // --- CORREÇÃO APLICADA AQUI ---
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .iso8601
        let decodedResponse = try decoder.decode(GeminiResponse.self, from: responseData)
        // --- FIM DA CORREÇÃO ---
        
        print("Plano diário recebido e decodificado!")
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
