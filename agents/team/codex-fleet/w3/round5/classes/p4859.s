# n=5 model=out iset=I1 prefix14_class=4859
mov S1, P3
mov S0, P0
cmp P0, P1
cmovge P0, P1
cmovl S0, P1
mov S2, P0
cmp P2, S1
cmovl P3, P2
cmovg S1, P2
cmp P0, P3
cmovl S2, P3
cmovle P3, P0
cmp S1, S0
cmovle P2, S1
