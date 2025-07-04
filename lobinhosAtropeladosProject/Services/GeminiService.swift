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
        

        let prompt = """
        Você é um Estrategista de Produtividade Acadêmica de Elite. Sua missão é analisar o perfil de um estudante e suas tarefas para criar um plano de estudos otimizado e realista para um bloco de **5 horas (300 minutos)**.

        INFORMAÇÕES DISPONÍVEIS:
        - Perfil do Estudante: Cursa \(perfilUsuario.curso) (\(perfilUsuario.periodo)), e prefere um estilo de organização focado em: "\(perfilUsuario.estiloOrganizacao ?? "Não definido")".
        - Tarefas Pendentes: A lista de tarefas a serem planejadas. O campo `duracao_minutos` está zerado e deve ser estimado por você.
        - Histórico de Conclusão: Tarefas que o estudante já completou.

        SEU PROCESSO DE ANÁLISE DEVE SEGUIR RIGOROSAMENTE ESTES 3 PASSOS:

        **Passo 1: ESTIMAR A DURAÇÃO (Análise Preditiva).**
        Para cada tarefa em "TAREFAS PENDENTES", sua primeira ação é preencher o campo `duracao_minutos`. Sua estimativa deve ser precisa.
        - **Fonte Primária:** O `Histórico de Conclusão`. Se no passado o estudante concluiu uma tarefa de "Cálculo Vetorial" com dificuldade "Alta", use a duração dessa tarefa como base para estimar uma nova tarefa similar.
        - **Fonte Secundária:** Se não houver histórico relevante, use o `título`, `descrição` e `dificuldade` da tarefa, cruzando com o `curso` e `período` do estudante para inferir o esforço necessário. Um estudante do 8º período de Engenharia levará menos tempo em uma tarefa de "Cálculo I" do que um do 2º período.

        **Passo 2: PRIORIZAR A LISTA COMPLETA (Análise Estratégica).**
        Com as durações estimadas, atribua uma `prioridade` numérica (1 = mais alta) para TODAS as tarefas pendentes. Siga esta hierarquia de regras:
        - **Regra de Ouro: Prazo de Entrega é Soberano.** Uma tarefa com `data_entrega` para amanhã tem prioridade mais alta do que qualquer outra tarefa para a próxima semana, independentemente da dificuldade.
        - **Regra Comportamental: Análise de Procrastinação.** Analise o `Histórico de Conclusão`. Compare a `data_conclusao` com a `data_entrega`. Se o estudante consistentemente conclui tarefas perto do prazo, ele tem um perfil procrastinador para aquele tipo de tarefa. Aumente sutilmente a prioridade de tarefas futuras similares para incentivá-lo a começar mais cedo. Se ele entrega com antecedência, ele é um bom planejador.
        - **Regra de Contexto:** Use o campo `dificuldade` como critério de desempate.

        **Passo 3: SELECIONAR O PLANO DO DIA (Montagem do Plano de Ação).**
        Com a lista final priorizada, monte o "Plano do Dia". Adicione tarefas em ordem estrita de prioridade (da 1 em diante) até que a soma das `duracao_minutos` (que você estimou) se aproxime de 300 minutos, **sem jamais ultrapassar este limite**.
        - **Critério de Desempate:** Se duas tarefas tiverem a mesma prioridade, use o `estiloOrganizacao` do usuário para decidir qual incluir. Se ele prefere um dia "tranquilo", escolha a de menor duração. Se prefere "foco total", escolha a que "destrava" outras tarefas.

        FORMATO DA RESPOSTA:
        Sua resposta DEVE ser um único objeto JSON com DUAS chaves:
        1.  `"planoDoDia"`: um array contendo **apenas** as tarefas que você selecionou para o plano de hoje.
        2.  `"naoPlanejado"`: um array contendo **todas as outras tarefas pendentes** que não couberam no plano de hoje.
        
        É CRUCIAL que TODAS as tarefas pendentes originais estejam em um desses dois arrays e que TODAS tenham os campos `prioridade` e `duracao_minutos` preenchidos por você. Não inclua texto fora do objeto JSON.

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
