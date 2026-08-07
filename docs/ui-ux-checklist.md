# UI/UX Checklist

Checklist rapido para manter as telas consistentes, agradaveis e intuitivas.

## Visual e consistencia

- Usar tokens globais em src/styles/tokens.scss (cores, spacing, radius, sombra).
- Manter tipografia padrao definida em src/styles/main.scss.
- Evitar cores hardcoded em componentes quando houver token equivalente.
- Reutilizar estados visuais padrao de botoes, inputs e cards.

## Acessibilidade

- Todo campo deve ter label associado por for/id.
- Campos com validacao devem expor aria-invalid quando invalidos.
- Mensagens de erro devem ser vinculadas por aria-describedby.
- Navegacao por teclado deve ter foco visivel com :focus-visible.
- Alvos de toque (checkbox/radio/botao) devem ter area minima de 44px.

## Microcopy

- Preferir linguagem simples e humana, com tom acolhedor.
- Evitar jargao tecnico quando nao agrega ao usuario final.
- Mensagens de erro devem sugerir proximo passo.
- Estados de carregamento devem explicar o que esta acontecendo.

## Responsividade

- Construir layout mobile-first.
- Garantir leitura e clique confortaveis em 360px de largura.
- Validar quebra de grid em 520px, 768px e 1024px.

## Performance percebida

- Em operacoes assincronas longas, bloquear interacao e exibir loading central.
- Evitar mudancas bruscas de layout durante carregamento.
- Priorizar feedback imediato apos clique em acoes principais.

## Revisao antes de merge

- Rodar build do frontend sem warnings criticos.
- Validar fluxo principal ponta a ponta (questionario -> resultado -> WhatsApp).
- Confirmar que erros e estados vazios tem texto claro.
