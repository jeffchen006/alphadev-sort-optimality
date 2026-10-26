# n=5 model=out iset=I1 prefix14_class=5072
cmp P1, P3
cmovge S0, P1
cmovle S0, P3
cmovle P3, P1
mov S2, P0
cmp P2, P0
mov S1, P3
cmovg S2, P2
cmovle P0, P2
cmp S1, P0
cmovge S1, P0
cmovg P0, P3
cmp S2, S0
mov P3, S2
