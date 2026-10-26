# n=5 model=out iset=I1 prefix14_class=8147
mov S0, P2
cmp P2, P1
cmovg S0, P1
cmovg P1, P2
cmp P0, P3
cmovge S2, P3
cmovg P3, P0
cmovge P0, S2
cmp S0, P0
mov P2, S0
cmovg P2, P0
cmovle S0, P0
cmp P3, P1
cmovle S1, P1
