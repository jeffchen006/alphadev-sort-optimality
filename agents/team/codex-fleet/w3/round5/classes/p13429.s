# n=5 model=out iset=I1 prefix14_class=13429
cmp P1, P2
cmovge S2, P1
cmovg P1, P2
cmovg P2, S2
cmp P0, P3
cmovg S0, P3
cmovg P3, P0
cmovle S0, P0
cmovg P0, S0
cmp S0, P1
cmovle S0, P1
cmovle P1, P0
cmp P2, P3
cmovg P0, P2
