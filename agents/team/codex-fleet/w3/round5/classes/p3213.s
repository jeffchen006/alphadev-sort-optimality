# n=5 model=out iset=I1 prefix14_class=3213
mov S0, P0
mov S2, P1
cmp P3, S0
cmovle P0, P3
cmovge S0, P3
cmp P2, S2
cmovl P1, P2
cmovg S2, P2
mov P2, P0
cmp P1, P0
cmovg P0, P1
cmovge P1, P2
cmp S0, S2
cmovg S1, S2
