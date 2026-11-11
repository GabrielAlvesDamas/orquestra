---
name: orquestrar
description: Transforma a sessão principal em orquestradora do harness multiagente — tria a tarefa, escolhe o fluxo, despacha os agentes do orquestra (pesquisador, arquiteto, implementador, testador, revisor, produto, designer, redator, ops) e conecta seus resultados via .harness/. Use quando o usuário pedir /orquestrar ou uma tarefa com várias etapas.
---

# Orquestração do harness

Você (sessão principal) é a orquestradora. Subagentes não falam entre si: **toda conexão passa por você**, via arquivos em `.harness/<tarefa>/`.

## 1. Triagem
- Tarefa simples (1 arquivo, pergunta rápida, ajuste óbvio): faça você mesma, sem agentes. Mesmo sozinha, o padrão é o mesmo: mudança de código vem com teste que a cobre e a suíte do projeto passando.
- Caso contrário: crie um slug curto para a tarefa e o diretório `.harness/<slug>/`. Se ele já existir, use outro slug: arquivos de uma execução antiga contaminam a nova. Adicione `.harness/` ao `.gitignore` se houver repositório git.

## 2. Escolha o fluxo
| Tipo | Fluxo |
|---|---|
| Código (feature, bug, refactor) | pesquisador → arquiteto → implementador → testador → revisor |
| Código com interface (tela, componente) | pesquisador → designer → arquiteto → implementador → testador → revisor (produto antes do designer se faltar spec) |
| Produto / design | pesquisador → produto → designer → revisor |
| Conteúdo / docs | pesquisador → redator → revisor |
| Automação / ops | arquiteto → ops → testador → revisor |

Pule etapas que não agregam (ex.: sem pesquisa quando o contexto já está claro) e diga ao usuário qual fluxo vai usar.

## 3. Despacho
Ao chamar cada agente (tipo `orquestra:<agente>`), o prompt deve conter:
- O objetivo da tarefa em 1–2 frases e o diretório `.harness/<slug>/`.
- Quais arquivos anteriores ler e em qual arquivo gravar: `01-pesquisa.md`, `02-plano.md`, `03-implementacao.md`, `04-testes.md`, `05-revisao.md` (produto/designer/redator/ops usam `03-<agente>.md`; se produto/designer vierem antes do arquiteto, mande o arquiteto ler os `03-*.md` já gravados e copiar para o plano os critérios e o texto de `THIRD_PARTY_LICENSES.md`).
- O revisor só lê: antes de chamá-lo, rode `{ git status --porcelain -uall; git diff HEAD; } > .harness/<slug>/04-diff.txt` (a cada rodada) e, depois, a resposta dele em `05-revisao.md`.

Status que os agentes devolvem: OK | FALHOU | REPROVADO | BLOQUEADO.

**Espera:** cada etapa depende da anterior, então chame o agente em primeiro plano (`run_in_background: false`). Nunca termine o turno esperando um agente: o fluxo para ali.

**Paralelismo:** chame na mesma mensagem só agentes que não alteram arquivos (várias perguntas de pesquisa; cada pesquisador grava em arquivo próprio: `01-pesquisa-a.md`, `01-pesquisa-b.md`). Etapas de implementação rodam em sequência: compartilham a mesma cópia de trabalho, e builds/testes simultâneos dão falhas falsas.

## 4. Laços de correção
- Testador com FALHOU ou revisor com REPROVADO → devolva ao implementador (ou produto/designer/redator/ops) com o arquivo do achado. Depois da correção, **rode de novo testador → revisor** (as etapas que o fluxo tiver), gravando `04-testes-2.md`, `05-revisao-2.md`.
- **No máximo 2 voltas no total da tarefa** (teste e revisão somados); depois, pare e pergunte ao usuário.
- Falhas pré-existentes (na linha de base do implementador) não geram volta: liste-as como pendência.
- Agente com BLOQUEADO → resolva você (mais pesquisa, ajuste no plano) ou pergunte ao usuário.

## 5. Entrega
Resumo ao usuário: resultado primeiro, depois o que cada etapa fez, veredito do revisor, pendências e onde estão os arquivos em `.harness/<slug>/`. Commit/push só se o usuário pedir.
