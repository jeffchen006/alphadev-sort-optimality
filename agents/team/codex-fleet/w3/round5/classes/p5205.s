# n=5 model=out iset=I1 prefix14_class=5205
mov S2, P2
cmp P2, P1
mov S1, P0
cmovle P2, P1
cmovge S2, P1
cmp P3, P0
cmovl P0, P3
cmovl P3, S1
cmp S2, P0
cmovge S0, S2
cmovg S2, P0
cmovge P0, S0
mov P1, P3
cmp P2, P3
