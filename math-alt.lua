-- math-alt.lua
-- For Typst/PDF-UA-1 output: adds alt text to math equations using the
-- LaTeX source as the text alternative. Uses pandoc.write to get the
-- already-converted Typst math syntax, then wraps it so Typst can attach
-- the alt attribute.

function Math(el)
  if FORMAT ~= "typst" then return nil end

  -- Get the Typst-converted math string via pandoc's own Typst writer
  local tmp = pandoc.Pandoc({ pandoc.Para({ el }) })
  local typst = pandoc.write(tmp, "typst"):match("^%s*(.-)%s*$")

  -- Escape the LaTeX source for use as a Typst string literal
  local alt = el.text
    :gsub("\\", "\\\\")
    :gsub('"', '\\"')
    :gsub("\n", " ")

  local is_block = tostring(el.mathtype == "DisplayMath")

  -- Extract body from a temp equation, then recreate with alt text.
  -- Can't use ..it.fields() directly in a show rule because Typst doesn't
  -- expose `alt` as a filterable/checkable field, causing infinite recursion.
  local code = string.format(
    '#{ let _q = %s; math.equation(_q.body, alt: "%s", block: %s) }',
    typst, alt, is_block
  )

  return pandoc.RawInline("typst", code)
end
