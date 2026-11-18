" Define Liquid tags ({% ... %}) and variables ({{ ... }}) and exclude them from spellcheck
syntax region liquidTag start=/{%/ end=/%}/ contains=@NoSpell
syntax region liquidVar start=/{{/ end=/}}/ contains=@NoSpell
