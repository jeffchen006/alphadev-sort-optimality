# n=5 model=out iset=I1 prefix14_class=11647
cmp P1, P2
mov S1, P3
mov S0, P2
cmovl P2, P1
cmovg S0, P1
cmp S1, P0
mov S2, S0
cmovle P3, P0
cmovg S1, P0
cmp P3, S2
cmovl S2, P3
cmovge S0, P3
cmp S1, P2
cmovle P1, P2
