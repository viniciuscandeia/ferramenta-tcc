-- pandoc-tabela-wrap.lua
-- Evita que tabelas estourem a largura da página no PDF (LaTeX) e quebra
-- caminhos/IDs longos em código inline DENTRO de células.
-- Carregado por md_to_pdf.sh via --lua-filter.

local ZWSP = utf8.char(0x200B)  -- espaço de largura zero (ponto de quebra invisível)

local function quebrar_codigo_longo(txt)
  -- ponto de quebra após / . _ - em strings longas (caminhos, IDs)
  return (txt:gsub('([/%._%-])', '%1' .. ZWSP))
end

-- aplicado SÓ dentro de células de tabela (não toca títulos/.toc)
local break_code = {
  Code = function(el)
    if el.text and #el.text > 12 then
      el.text = quebrar_codigo_longo(el.text)
      return el
    end
  end
}

function Table(tbl)
  -- 1) quebrar código longo apenas dentro das células
  tbl = pandoc.walk_block(tbl, break_code)

  -- 2) tabelas com >= 3 colunas: larguras iguais -> writer LaTeX emite colunas
  --    p{} (que quebram o texto) em vez de colunas l (sem quebra) -> sem overflow
  local ncols = #tbl.colspecs
  if ncols >= 3 then
    local w = 1.0 / ncols
    for i = 1, ncols do
      tbl.colspecs[i] = { tbl.colspecs[i][1], w }
    end
  end
  return tbl
end
