# n=5 model=out iset=I1 prefix14_class=1738
mov S0, P3
cmp S0, P0
cmovl S0, P0
cmovl P0, P3
cmp P1, P2
cmovle P3, P2
cmovl P2, P1
cmovle P1, P3
mov S1, P0
cmp P0, P2
mov S2, S0
cmovle S1, P2
cmovge P0, P2
cmp P1, S2
