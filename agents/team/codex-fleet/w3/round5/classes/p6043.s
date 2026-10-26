# n=5 model=out iset=I1 prefix14_class=6043
cmp P1, P3
mov S0, P3
cmovl P3, P1
cmovg S0, P1
cmp P2, P0
mov S2, S0
cmovl S1, P0
cmovle P0, P2
cmovl P2, S1
cmp P2, S0
cmovge S2, P2
mov S2, P0
cmovle S0, P2
cmp S2, P3
