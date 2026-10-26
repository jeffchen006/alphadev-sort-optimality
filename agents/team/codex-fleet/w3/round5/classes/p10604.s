# n=5 model=out iset=I1 prefix14_class=10604
mov S0, P1
cmp P2, P0
cmovge S1, P2
cmovg P2, P0
cmovge P0, S1
cmp P3, S0
cmovl S0, P3
cmovle P3, P1
cmovge P1, P3
cmp P1, P0
cmovl P1, P0
cmovle P0, P3
cmp S0, P2
cmovg S2, P2
