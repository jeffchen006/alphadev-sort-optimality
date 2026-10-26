# n=5 model=out iset=I1 prefix14_class=11828
mov S1, P3
mov S2, P2
cmp P0, P3
cmovl S1, P0
cmovl P0, P3
cmp S2, P1
cmovle P2, P1
cmovl P1, S2
cmp P2, P0
mov S0, P0
cmovg S0, P2
cmovge P2, P0
cmp S1, P1
cmovge P0, P2
