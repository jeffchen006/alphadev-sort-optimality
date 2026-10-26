# n=5 model=out iset=I1 prefix14_class=9046
cmp P3, P2
mov S1, P2
cmovl S1, P3
cmovl P3, P2
cmp P1, P0
cmovg S0, P0
cmovge P0, P1
cmovle S0, P1
cmp P3, P0
cmovle P2, P3
cmovle P3, P0
mov S2, S0
cmovl P0, P2
cmp S0, S1
