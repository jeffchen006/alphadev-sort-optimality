# n=5 model=out iset=I1 prefix14_class=13472
mov S0, P3
cmp P2, S0
cmovl P3, P2
cmovg S0, P2
cmp P1, P0
mov S1, P0
cmovl S1, P1
cmovle P1, P0
mov S2, S1
cmp S2, P3
cmovge S1, P3
cmovl S2, P3
cmp S0, P1
cmovle S1, P1
