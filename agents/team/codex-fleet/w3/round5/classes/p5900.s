# n=5 model=out iset=I1 prefix14_class=5900
cmp P2, P0
cmovl S2, P0
cmovge S2, P2
cmovge P2, P0
mov S1, P1
cmp P3, S1
cmovge S1, P3
cmovle P1, P3
cmp S1, S2
mov P3, P2
mov S0, S2
cmovg S0, S1
cmovl S2, S1
mov S0, S2
