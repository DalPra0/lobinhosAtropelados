import Foundation
import GoogleGenerativeAI

class GeminiService {
    
    private var generativeModel: GenerativeModel
    
    init() {
        let config = GenerationConfig(
            responseMIMEType: "application/json"
        )
        
        self.generativeModel = GenerativeModel(
            name: "gemini-1.5-flash",
            apiKey: APIKeyManager.geminiKey,
            generationConfig: config
        )
    }
    
    func gerarPlanoDiario(
        tarefasPendentes: [Tarefa],
        tarefasConcluidas: [Tarefa],
        perfilUsuario: User
    ) async throws -> (planoDoDia: [Tarefa], naoPlanejado: [Tarefa]) {
        
        guard !tarefasPendentes.isEmpty else {
            return (planoDoDia: [], naoPlanejado: [])
        }
        
        // --- PROMPT TOTALMENTE REESCRITO ---
        let prompt = """
        Você é um Estrategista de Produtividade Acadêmica de Elite. Sua missão é analisar o perfil de um estudante e suas tarefas para criar um plano de estudos focado e realista.

        INFORMAÇÕES DISPONÍVEIS:
        - Perfil do Estudante: Cursa \(perfilUsuario.curso) (\(perfilUsuario.periodo)).
        - Estilo de Organização Preferido: "\(perfilUsuario.estiloOrganizacao ?? "Não definido")". Este é o fator MAIS IMPORTANTE para montar o plano do dia.
        - Tarefas Pendentes: A lista de tarefas a serem planejadas.
        - Histórico de Conclusão: Tarefas que o estudante já completou, use isso para entender o comportamento dele.

        SEU PROCESSO DE ANÁLISE DEVE SEGUIR RIGOROSAMENTE ESTES 2 PASSOS:

        **Passo 1: PRIORIZAR A LISTA COMPLETA (Análise Estratégica).**
        Sua primeira e única tarefa de análise é atribuir uma `prioridade` numérica (1 = mais alta, 2, 3, etc.) para TODAS as tarefas pendentes. Siga esta hierarquia de regras:
        - **Regra de Ouro: Prazo de Entrega é Soberano.** Uma tarefa com `data_entrega` para amanhã tem prioridade mais alta do que qualquer outra tarefa para a próxima semana, independentemente da dificuldade.
        - **Regra Comportamental: Análise de Procrastinação.** Analise o `Histórico de Conclusão`. Compare a `data_conclusao` com a `data_entrega`. Se o estudante consistentemente conclui tarefas perto do prazo, ele tem um perfil procrastinador. Aumente sutilmente a prioridade de tarefas futuras similares para incentivá-lo a começar mais cedo.
        - **Regra de Contexto:** Use o campo `dificuldade` como critério de desempate final.

        **Passo 2: SELECIONAR O PLANO DO DIA (Montagem do Plano de Ação).**
        Com a lista final priorizada, monte o "Plano do Dia". A quantidade de tarefas a serem selecionadas depende DIRETAMENTE do `Estilo de Organização` do usuário:
        - Se o estilo for "Poucas tarefas e um dia tranquilo.": Selecione exatamente as **2 tarefas** de maior prioridade.
        - Se o estilo for "Algumas tarefas, mas sem sobrecarregar meu dia." ou "Ser produtivo, mas ter pausas para um descanso.": Selecione exatamente as **4 tarefas** de maior prioridade.
        - Se o estilo for "Foco total, quero finalizar minhas tarefas o mais rápido possível.": Selecione exatamente as **6 tarefas** de maior prioridade.

        FORMATO DA RESPOSTA:
        Sua resposta DEVE ser um único objeto JSON com DUAS chaves:
        1.  `"planoDoDia"`: um array contendo **apenas** as tarefas que você selecionou para o plano de hoje.
        2.  `"naoPlanejado"`: um array contendo **todas as outras tarefas pendentes** que não couberam no plano de hoje.
        
        É CRUCIAL que TODAS as tarefas pendentes originais estejam em um desses dois arrays e que TODAS tenham o campo `prioridade` preenchido por você. Não inclua nenhum outro campo que não exista na estrutura original da tarefa. Não inclua texto fora do objeto JSON.

        DADOS PARA ANÁLISE:
        - TAREFAS PENDENTES:
        \(tarefasPendentes.toJsonString())
        
        - HISTÓRICO DE CONCLUSÃO:
        \(tarefasConcluidas.toJsonString())
        """
        
        print("Enviando prompt de Estrategista de Produtividade para o Gemini...")
        let response = try await generativeModel.generateContent(prompt)
        
        guard let textResponse = response.text,
              let responseData = textResponse.data(using: .utf8) else {
            throw NSError(domain: "GeminiServiceError", code: 1, userInfo: [NSLocalizedDescriptionKey: "Resposta inválida do Gemini."])
        }
        
        struct GeminiResponse: Codable {
            let planoDoDia: [Tarefa]
            let naoPlanejado: [Tarefa]
        }
        
        let decodedResponse = try JSONDecoder().decode(GeminiResponse.self, from: responseData)
        
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
