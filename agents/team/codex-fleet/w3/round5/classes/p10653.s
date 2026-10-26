# n=5 model=out iset=I1 prefix14_class=10653
cmp P0, P1
cmovl S1, P1
cmovle P1, P0
mov S2, P2
cmovl P0, S1
cmp P3, P2
mov S0, P0
cmovge P2, P3
cmovg P3, S2
cmp S0, P2
cmovg S0, P2
cmovge P2, P0
cmp P3, P1
cmovge S2, P1
