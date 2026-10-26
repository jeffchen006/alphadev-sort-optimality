# n=5 model=out iset=I1 prefix14_class=13549
cmp P0, P2
cmovle S0, P0
cmovg S0, P2
cmovle P0, P2
cmp P3, P1
cmovl P2, P1
cmovle P1, P3
cmovl P3, P2
mov S2, P1
cmp S0, P1
cmovl S2, S0
cmovl S0, P1
cmp P3, P0
cmovge P1, P0
