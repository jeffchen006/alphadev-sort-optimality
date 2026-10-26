# n=5 model=out iset=I1 prefix14_class=9565
cmp P2, P3
cmovle S0, P2
cmovle P2, P3
mov S2, P1
cmovl P3, S0
cmp P1, P0
cmovg S2, P0
cmovl P1, P0
cmp P1, P2
cmovl S1, P2
cmovge S1, P1
cmovle P2, P1
cmp S2, P3
mov P1, S2
