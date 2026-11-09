---
name: orquestrar
description: Transforma a sessão principal em orquestradora do harness multiagente — tria a tarefa, escolhe o fluxo, despacha os agentes do orquestra (pesquisador, arquiteto, implementador, testador, revisor, produto, redator, ops) e conecta seus resultados via .harness/. Use quando o usuário pedir /orquestrar ou uma tarefa com várias etapas.
---

# Orquestração do harness

Você (sessão principal) é a orquestradora. Subagentes não falam entre si: **toda conexão passa por você**, via arquivos em `.harness/<tarefa>/`.

## 1. Triagem
- Tarefa simples (1 arquivo, pergunta rápida, ajuste óbvio): faça você mesma, sem agentes.
- Caso contrário: crie um slug curto para a tarefa e o diretório `.harness/<slug>/`. Adicione `.harness/` ao `.gitignore` se houver repositório git.

## 2. Escolha o fluxo
| Tipo | Fluxo |
|---|---|
| Código (feature, bug, refactor) | pesquisador → arquiteto → implementador → testador → revisor |
| Produto / design | pesquisador → produto → revisor |
| Conteúdo / docs | pesquisador → redator → revisor |
| Automação / ops | arquiteto → ops → testador |

Pule etapas que não agregam (ex.: sem pesquisa quando o contexto já está claro) e diga ao usuário qual fluxo vai usar.

## 3. Despacho
Ao chamar cada agente (tipo `orquestra:<agente>`), o prompt deve conter:
- O objetivo da tarefa em 1–2 frases e o diretório `.harness/<slug>/`.
- Quais arquivos anteriores ler e em qual arquivo gravar: `01-pesquisa.md`, `02-plano.md`, `03-implementacao.md`, `04-testes.md`, `05-revisao.md` (produto/redator/ops usam `03-<agente>.md`).
- Para agentes só-leitura (pesquisador, arquiteto, revisor): grave você mesma a resposta deles no arquivo correspondente.

**Paralelismo:** chame na mesma mensagem os agentes independentes (várias perguntas de pesquisa; etapas do plano marcadas como paralelas que tocam arquivos diferentes).

## 4. Laços de correção
- Testador com FALHOU ou revisor com REPROVADO → devolva ao implementador (ou produto/redator/ops) com o arquivo do achado. **No máximo 2 voltas**; depois, pare e pergunte ao usuário.
- Agente com BLOQUEADO → resolva você (mais pesquisa, ajuste no plano) ou pergunte ao usuário.

## 5. Entrega
Resumo ao usuário: resultado primeiro, depois o que cada etapa fez, veredito do revisor, pendências e onde estão os arquivos em `.harness/<slug>/`. Commit/push só se o usuário pedir.
