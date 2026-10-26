# n=5 model=out iset=I1 prefix14_class=5974
cmp P0, P2
mov S0, P2
cmovle S0, P0
cmovge P2, P0
mov S1, P1
cmp S1, P3
cmovl S1, P3
cmovg P1, P3
mov S2, P2
cmp S1, S2
cmovl P2, S1
cmovl S1, S2
cmp P1, S0
cmovle P0, P1
