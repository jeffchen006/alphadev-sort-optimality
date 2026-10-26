# n=5 model=out iset=I1 prefix14_class=7552
cmp P0, P1
mov S0, P1
cmovg S0, P0
mov S2, P2
cmovg P0, P1
cmp P3, P2
cmovge S2, P3
cmovg P3, P2
cmp P0, P3
cmovle P2, P0
cmovl P0, P3
mov S1, S0
cmovle P3, P2
cmp S2, S0
