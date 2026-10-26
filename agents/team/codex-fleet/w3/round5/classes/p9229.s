# n=5 model=out iset=I1 prefix14_class=9229
cmp P2, P1
cmovge S0, P1
cmovge P1, P2
cmovg P2, S0
mov S1, P2
mov S2, P0
cmp P3, P0
cmovg S2, P3
cmovl P0, P3
cmp S1, P0
cmovge S1, P0
cmovle P2, P0
cmp P1, S2
cmovle P0, P1
