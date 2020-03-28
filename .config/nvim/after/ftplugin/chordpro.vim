function! Chords() abort
    python3 << EOF
import vim
import re
from collections import Counter

matches = re.findall(r"\[.+?\]", "\n".join(vim.current.buffer[:]))
counter = Counter(matches)
matches = [item[0] for item in counter.most_common()]
EOF
    return py3eval('matches')
endfunction

" let b:mucomplete_wordlist = Chords()
