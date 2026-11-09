# orquestra

Licença: MIT.

Plugin do Claude Code que transforma a sessão principal em orquestradora de 8 agentes especializados.

## Instalar
```
/plugin marketplace add <usuario>/orquestra
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
| pesquisador | Fatos com fonte (código/web), só leitura | sonnet |
| arquiteto | Plano com etapas e critérios de aceite, só leitura | opus |
| implementador | Menor diff completo | claude-opus-5-5 |
| testador | Testes com evidência | sonnet |
| revisor | Veredito APROVADO/REPROVADO | opus |
| produto | Specs, histórias, UX copy | sonnet |
| redator | Docs e textos | sonnet |
| ops | CI/CD, scripts, automações | sonnet |

## Como os agentes se conectam
Subagentes não chamam uns aos outros. A sessão principal (skill `orquestrar`) despacha cada um e passa o contexto por arquivos em `.harness/<tarefa>/` (`01-pesquisa.md`, `02-plano.md`, ...). Revisor reprovou → volta ao implementador, no máximo 2 vezes.
