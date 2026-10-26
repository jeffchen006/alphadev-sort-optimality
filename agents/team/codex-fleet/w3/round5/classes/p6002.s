# n=5 model=out iset=I1 prefix14_class=6002
mov S1, P2
mov S0, P3
cmp S1, P1
cmovg S1, P1
cmovle P2, P1
cmp P0, P3
cmovl P3, P0
cmovg S0, P0
mov S2, S0
cmp P2, S0
cmovge S2, P2
cmovg P2, S0
cmp P3, S1
cmovl S2, S1
