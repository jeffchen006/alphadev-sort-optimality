# n=5 model=out iset=I1 prefix14_class=12900
mov S0, P3
cmp P3, P1
cmovge P3, P1
cmovl S0, P1
cmp P0, P2
cmovle S1, P2
cmovl P2, P0
cmovl P0, S1
mov S2, P2
cmp P2, P3
cmovl P2, P3
cmovl P3, S2
cmp S0, P0
cmovle S1, S0
