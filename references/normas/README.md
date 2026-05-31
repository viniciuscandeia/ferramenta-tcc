# Normas e Referências Técnicas

Documentos normativos e referências bibliográficas usados como base técnica da ferramenta.
Arquivos físicos presentes nesta pasta estão indicados com ✅.
Referências proprietárias (não distribuíveis) têm apenas metadado e link de acesso.

---

## Arquivos presentes nesta pasta

| Arquivo | Referência | Licença | Status |
|---|---|---|---|
| `cpre_foundationlevel_handbook_BR_v1.2.md` | IREB CPRE Foundation Level Handbook v1.2 — PT-BR | Livre — IREB freely distributable | ✅ Completo (markdown) |
| `cpre_foundationlevel_handbook_en_v1.2.pdf` | IREB CPRE Foundation Level Handbook v1.2 — EN | Livre — IREB freely distributable | ✅ Completo (PDF, 158pp) |
| `ears-mavin-2009.pdf` | EARS — Mavin et al., IEEE RE'09 | Acadêmico — IEEE © 2009 | ✅ Paper completo (PDF, 8pp) |
| `rfc2119.txt` | RFC 2119 — Bradner, IETF 1997 | IETF — domínio público | ✅ Completo (TXT) |
| `rfc8174.txt` | RFC 8174 — Leiba, IETF 2017 | IETF — domínio público | ✅ Completo (TXT) |
| `gorski-stadzisz-problem-based-srs-resi-2016.pdf` | Problem-Based SRS — Gorski & Stadzisz, RESI 2016 | Open access — IBEPES | ✅ Paper completo (PDF, 27pp) |
| `mare-jin-2024-arxiv-2405.03256.pdf` | MARE framework — Jin et al., arXiv 2024 | Open access — arXiv | ✅ Paper completo (PDF, 4pp) |
| `iso/iso-iec-ieee-29148-2018-preview.pdf` | ISO/IEC/IEEE 29148:2018 — Requirements Engineering | Proprietária — ISO | ⚠️ Preview oficial (14pp de ~150) |
| `iso/README.md` | ISO/IEC 25010:2023 — Software Product Quality | Proprietária — ISO | ❌ Apenas metadado + links |

---

## Onde cada referência é usada

| Referência | Uso na ferramenta |
|---|---|
| IREB CPRE FL Handbook | Base da metodologia ER: tipos de requisito, atributos de qualidade IREB §3.8, SRS IREB §3.3.3 |
| EARS (Mavin 2009) | Sintaxe obrigatória dos requisitos em `requisito-ears` e no SRS gerado |
| RFC 2119 + RFC 8174 | Vocabulário MUST/SHOULD/MAY em `requisito-ears`; RFC 8174 clarifica que só maiúsculas têm valor normativo |
| ISO/IEC/IEEE 29148 | Template SRS em `srs-ireb-template`; seções obrigatórias do documento final |
| ISO/IEC 25010 | Categorias de qualidade em `classificacao-rf-rnf` e `content/catalogos-seed/rnfs-tipicos.md` |
| Gorski & Stadzisz (2016) | Arquitetura Problem-Based-SRS: D10 detection-based recovery, slots estruturados, algoritmo Zigzag |
| MARE (Jin et al., 2024) | Topologia MARE-style para os 5 sub-agentes da ferramenta (D6 revisada) |
| Vazquez & Simões (2016) | Técnicas ER: elicitação (cap. 7), classificação RF/RNF (cap. 5), stakeholders (cap. 6), pautas (cap. 8) |
| Reinehr (2020) | Base complementar: stakeholders (cap. 1), entrevistas, priorização, conflitos (cap. 4) |
| Nielsen (1993) | 5 dimensões de usabilidade em `content/catalogos-seed/rnfs-tipicos.md` seção Usabilidade |
| Wiegers & Beatty (2013) | Catálogo de RFs típicos em `content/catalogos-seed/rfs-tipicos.md` |
| Robertson & Robertson (2012) | Catálogo de RFs (Volere §8-9), cenários como técnica de elicitação (cap. 9) em `cenario-narrativa` |
| Pohl (2010) | Entrevistas estruturadas §22 em `entrevista-estruturada` |
| Alexander & Robertson (2004) | Onion Model para stakeholders em `content/catalogos-seed/stakeholders-tipicos.md` |
| IMS Global / ISO 19796-1 | Base para domínio Educação/LMS em `content/catalogos-seed/dominios/educacao.md` |

---

## Referências proprietárias (não distribuíveis — apenas metadado)

### ISO/IEC/IEEE 29148:2018
| Campo | Valor |
|---|---|
| Número | ISO/IEC/IEEE 29148:2018 |
| Título | Systems and software engineering — Life cycle processes — Requirements engineering |
| Acesso | [ieeexplore.ieee.org/document/8559686](https://ieeexplore.ieee.org/document/8559686) |
| Preview local | `iso/iso-iec-ieee-29148-2018-preview.pdf` (14pp) |

### ISO/IEC 25010:2023
| Campo | Valor |
|---|---|
| Número | ISO/IEC 25010:2023 |
| Título | Systems and software engineering — SQuaRE — Product quality model |
| Acesso | [iso.org/standard/78176.html](https://www.iso.org/standard/78176.html) |
| Preview | [iso.org/obp/ui/#iso:std:iso-iec:25010:en](https://www.iso.org/obp/ui/#iso:std:iso-iec:25010:en) |

### ISO/IEC 19796-1:2005
| Campo | Valor |
|---|---|
| Número | ISO/IEC 19796-1:2005 |
| Título | IT — Learning, education and training — Quality management, assurance and metrics |
| Acesso | [iso.org/standard/33934.html](https://www.iso.org/standard/33934.html) |

### Nielsen, J. "Usability Engineering" (1993)
| Campo | Valor |
|---|---|
| Autor | Jakob Nielsen |
| Título | Usability Engineering |
| Editora | Morgan Kaufmann / AP Professional |
| Ano | 1993 |
| ISBN | 978-0-12-518406-9 |
| Capítulo usado | Cap. 2 — 5 usability attributes (learnability, efficiency, memorability, errors, satisfaction) |

### Wiegers, K. & Beatty, J. "Software Requirements" 3rd ed. (2013)
| Campo | Valor |
|---|---|
| Autores | Karl Wiegers & Joy Beatty |
| Título | Software Requirements |
| Edição | 3ª |
| Editora | Microsoft Press |
| Ano | 2013 |
| ISBN | 978-0-7356-7584-1 |
| Uso | Catálogo de RFs típicos por categoria |

### Robertson, J. & Robertson, S. "Mastering the Requirements Process" 3rd ed. (2012)
| Campo | Valor |
|---|---|
| Autores | James Robertson & Suzanne Robertson |
| Título | Mastering the Requirements Process: Getting Requirements Right |
| Edição | 3ª |
| Editora | Addison-Wesley |
| Ano | 2012 |
| ISBN | 978-0-321-81574-3 |
| Capítulos usados | Volere template §8-9 (catálogo RFs), cap. 9 (cenários) |

### Pohl, K. "Requirements Engineering" (2010)
| Campo | Valor |
|---|---|
| Autor | Klaus Pohl |
| Título | Requirements Engineering: Fundamentals, Principles, and Techniques |
| Editora | Springer |
| Ano | 2010 |
| ISBN | 978-3-642-12577-5 |
| Capítulo usado | §22 — Interviews |

### Alexander, I. & Robertson, S. "Understanding Project Sociology by Modeling Stakeholders" (2004)
| Campo | Valor |
|---|---|
| Autores | Ian Alexander & Suzanne Robertson |
| Título | Understanding Project Sociology by Modeling Stakeholders |
| Publicação | IEEE Software, vol. 21, no. 1, pp. 23-27 |
| Ano | 2004 |
| DOI | 10.1109/MS.2004.1259186 |
| Uso | Onion Model para identificação de stakeholders |

### Grady, R.B. "Practical Software Metrics" (1992) — FURPS+
| Campo | Valor |
|---|---|
| Autor | Robert B. Grady |
| Título | Practical Software Metrics for Project Management and Process Improvement |
| Editora | Prentice-Hall / HP Press |
| Ano | 1992 |
| ISBN | 978-0-13-720384-4 |
| Uso | Framework FURPS+ em `content/catalogos-seed/rnfs-tipicos.md` |

### Vazquez, C.E. & Simões, G.S. (2016) — "Livro SON"
| Campo | Valor |
|---|---|
| Autores | Carlos Eduardo Vazquez & Guilherme Siqueira Simões |
| Título | Engenharia de Requisitos: software orientado ao negócio |
| Editora | Brasport |
| Ano | 2016 |
| ISBN | 978-85-7452-790-1 |
| Localização | `TCC/referencias/Engenharia de Requisitos - Software Orientado ao Negócio/` |
| Capítulos usados | 5 (tipos de requisito), 6 (stakeholders), 7 (elicitação), 8 (análise/pautas) |

### Reinehr, S. (2020) — "Livro 2"
| Campo | Valor |
|---|---|
| Autora | Sheila Reinehr |
| Título | Engenharia de Requisitos |
| Editora | Grupo A / Sagah |
| Ano | 2020 |
| ISBN | 978-65-5690-067-4 |
| Localização | `TCC/referencias/Engenharia de Requisitos - como levantar, documentar e validar/` |
| Uso | Stakeholders (cap. 1), entrevistas, priorização, conflitos (cap. 4) |

### "Livro 1" — identificação pendente
| Campo | Valor |
|---|---|
| Título presumido | Engenharia de Requisitos: Da demanda ao gerenciamento |
| Localização | `TCC/referencias/Engenharia de Requisitos - Da demanda ao gerenciamento/` |
| Status | **TODO:** confirmar autor/editora/ISBN. Pode ser notas de aula, não livro publicado. |
| Uso citado | RFs típicos (cap. 1-3), cenários de uso para domínio educação |

### IMS Global Learning Consortium
| Campo | Valor |
|---|---|
| Título | Learning Management Systems Interoperability |
| Organização | IMS Global Learning Consortium |
| Ano | 2020 |
| URL | https://www.imsglobal.org/activity/learning-management-systems |

---

## Como obter normas ISO completas

- **Portal CAPES** (acesso institucional): https://www.periodicos.capes.gov.br
- **ABNT**: convênio via IES brasileiras
- **ISO OBP**: previews em https://www.iso.org/obp

## Fontes originais (para re-download dos arquivos presentes)

| Arquivo | URL |
|---|---|
| IREB CPRE FL Handbook EN | https://cpre.ireb.org/en/downloads-and-resources/downloads |
| IREB CPRE FL Handbook BR | https://ireb.org/en/downloads |
| EARS paper | https://www.semanticscholar.org/paper/EARS-(Easy-Approach-to-Requirements-Syntax)-Mavin-Wilkinson/43cbe29306ba9dfa286f3a2d7469c4da9c8728a0 |
| RFC 2119 | https://www.rfc-editor.org/rfc/rfc2119.txt |
| RFC 8174 | https://www.rfc-editor.org/rfc/rfc8174.txt |
| Gorski & Stadzisz RESI 2016 | https://doi.org/10.21529/RESI.2016.1502002 |
| MARE arXiv 2024 | https://arxiv.org/abs/2405.03256 |
| ISO 29148 preview | https://cdn.standards.iteh.ai/samples/72089/62bb2ea1ef8b4f33a80d984f826267c1/ISO-IEC-IEEE-29148-2018.pdf |
