# orquestra

Licença: MIT.

Plugin do Claude Code que transforma a sessão principal em orquestradora de 9 agentes especializados.

## Instalar
```
/plugin marketplace add GabrielAlvesDamas/orquestra
/plugin install orquestra@orquestra
```

## Usar
```
/orquestrar <sua tarefa>
```
Ou chame um agente direto: "use o agente orquestra:revisor neste diff".

## Agentes
| Agente | Função | Modelo |
|---|---|---|
| pesquisador | Fatos com fonte (código/web); grava só em `.harness/` | sonnet |
| arquiteto | Plano com etapas, critérios de aceite e comandos de verificação; grava só em `.harness/` | opus |
| implementador | Menor diff completo, com linha de base dos testes | opus |
| testador | Testes com evidência | sonnet |
| revisor | Veredito APROVADO/REPROVADO | opus |
| produto | Specs, histórias, UX copy | sonnet |
| designer | Layout, tokens, estados, acessibilidade WCAG AA e assets gratuitos com licença verificada; grava só em `.harness/` | sonnet |
| redator | Docs e textos | sonnet |
| ops | CI/CD, scripts, automações | sonnet |

## Como os agentes se conectam
Subagentes não chamam uns aos outros. A sessão principal (skill `orquestrar`) despacha cada um e passa o contexto por arquivos em `.harness/<tarefa>/` (`01-pesquisa.md`, `02-plano.md`, ...). Teste falhou ou revisor reprovou → volta ao implementador e repete teste e revisão, no máximo 2 voltas por tarefa. Status padrão: OK | FALHOU | REPROVADO | BLOQUEADO.

## Validação
A cada push/PR (`.github/workflows/validar.yml`): JSON do plugin válidos e protocolo de handoff idêntico em todos os agentes.
