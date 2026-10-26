# n=5 model=out iset=I1 prefix14_class=13358
cmp P3, P1
cmovle S0, P3
cmovl P3, P1
mov S1, P2
cmovl P1, S0
cmp P0, P2
cmovge P2, P0
cmovl S1, P0
mov S2, P1
cmp S1, S2
cmovg S2, S1
cmovl P1, S1
cmp P2, P3
cmovle P0, P2
