# n=5 model=out iset=I1 prefix14_class=3067
cmp P0, P1
cmovge S0, P1
cmovg P1, P0
cmovge P0, S0
cmp P3, P2
mov S0, P3
cmovg S0, P2
cmovle P3, P2
mov S1, P3
cmp S0, P0
cmovg P2, S0
cmovg S0, P0
cmovg P0, P2
cmp P1, P3
