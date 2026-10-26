# n=5 model=out iset=I1 prefix14_class=9983
cmp P3, P2
cmovle S2, P2
cmovg S2, P3
cmovl P2, P3
mov S1, P1
cmp S1, P0
cmovle S1, P0
cmovl P0, P1
cmp S2, S1
cmovl P3, S1
mov S0, P0
cmovl S1, S2
cmovl S2, P3
mov S2, S1
