# n=5 model=out iset=I1 prefix14_class=13279
cmp P0, P2
cmovg S0, P0
mov S1, P3
cmovg P0, P2
cmovg P2, S0
cmp P3, P1
cmovge S1, P1
cmovle P3, P1
cmp S1, P0
cmovge P1, S1
cmovle P1, P0
cmovg S1, P0
cmp P3, P2
cmovg S0, P3
