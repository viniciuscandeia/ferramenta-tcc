# Normas e Referências Técnicas

Documentos normativos usados como base técnica da ferramenta. Fisicamente presentes nesta pasta para consulta direta.

## Índice

| Arquivo | Norma | Licença | Status |
|---|---|---|---|
| `cpre_foundationlevel_handbook_BR_v1.2.md` | IREB CPRE Foundation Level Handbook v1.2 — Português (BR) | Livre — IREB freely distributable | ✅ Completo (markdown) |
| `cpre_foundationlevel_handbook_en_v1.2.pdf` | IREB CPRE Foundation Level Handbook v1.2 — English | Livre — IREB freely distributable | ✅ Completo (PDF, 158pp) |
| `ears-mavin-2009.pdf` | EARS: Easy Approach to Requirements Syntax — Mavin et al., IEEE RE'09 | Acadêmico — IEEE © 2009 | ✅ Paper completo (PDF, ~8pp) |
| `rfc2119.txt` | RFC 2119 — Key words for use in RFCs (MUST/SHOULD/MAY) — Bradner, IETF 1997 | Domínio público — IETF | ✅ Completo (TXT) |
| `iso/iso-iec-ieee-29148-2018-preview.pdf` | ISO/IEC/IEEE 29148:2018 — Requirements Engineering | Proprietária — ISO | ⚠️ Preview oficial (14pp de ~150) |
| `iso/README.md` | ISO/IEC 25010:2023 — Software Product Quality Model | Proprietária — ISO | ❌ Apenas metadado + links |

## Por que cada norma está aqui

| Norma | Onde é usada na ferramenta |
|---|---|
| IREB CPRE FL Handbook | Base de toda a metodologia ER: tipos de requisito, atributos de qualidade, critérios IREB §3.8, artefatos SRS IREB §3.3.3 |
| EARS | Sintaxe obrigatória dos requisitos em `requisito-ears` e no SRS gerado |
| RFC 2119 | Vocabulário MUST/SHOULD/MAY usado em `requisito-ears` para grau de obrigatoriedade |
| ISO/IEC/IEEE 29148 | Template SRS em `srs-ireb-template`; seções obrigatórias do documento final |
| ISO/IEC 25010 | Categorias de requisitos de qualidade em `classificacao-rf-rnf` e catálogo `rnfs-tipicos.md` |

## Como obter ISO 29148 e ISO 25010 completos

Ambas são normas proprietárias. Acesso gratuito para pesquisa acadêmica:

- **Biblioteca da universidade**: ABNT disponibiliza via convênio para alunos da maioria das IES brasileiras
- **IEEE Xplore** (29148): https://ieeexplore.ieee.org/document/8559686 — acesso institucional
- **ISO OBP** (preview online de 25010): https://www.iso.org/obp/ui/#iso:std:iso-iec:25010:en
- **Compra direta**: ISO 29148 ~CHF 198 | ISO 25010 ~CHF 155

## Fontes originais (para re-download)

| Documento | URL oficial |
|---|---|
| IREB CPRE FL Handbook EN | https://cpre.ireb.org/en/downloads-and-resources/downloads |
| IREB CPRE FL Handbook BR | https://ireb.org/en/downloads |
| EARS paper | https://www.semanticscholar.org/paper/EARS-(Easy-Approach-to-Requirements-Syntax)-Mavin-Wilkinson/43cbe29306ba9dfa286f3a2d7469c4da9c8728a0 |
| RFC 2119 | https://www.rfc-editor.org/rfc/rfc2119.txt |
| ISO 29148 preview | https://cdn.standards.iteh.ai/samples/72089/62bb2ea1ef8b4f33a80d984f826267c1/ISO-IEC-IEEE-29148-2018.pdf |
