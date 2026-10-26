# n=5 model=out iset=I1 prefix14_class=13916
mov S2, P2
cmp S2, P1
cmovle P2, P1
cmovle P1, S2
mov S2, P3
cmp S2, P0
cmovle P3, P0
cmovg S2, P0
cmp P3, P2
cmovge S0, P2
cmovge P2, P3
cmovg P3, S0
cmp S2, P1
cmovle P2, S2
