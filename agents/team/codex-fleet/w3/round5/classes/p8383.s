# n=5 model=out iset=I1 prefix14_class=8383
mov S0, P1
cmp P0, P3
cmovge S2, P0
cmovle S2, P3
cmovle P3, P0
cmp P1, P2
cmovg S0, P2
cmovge P2, P1
cmp S2, P2
cmovle P1, S2
cmovl S2, P2
mov S1, S0
cmovle P2, P1
cmp S0, P3
