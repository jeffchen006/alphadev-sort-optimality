# n=5 model=out iset=I1 prefix14_class=8025
mov S1, P1
cmp P2, P3
cmovle S0, P3
cmovge S0, P2
cmovge P2, P3
cmp P1, P0
cmovle S1, P0
cmovg P1, P0
mov S2, P2
cmp P1, S2
cmovl S2, P1
cmovl P1, P2
cmp S0, S1
cmovle S2, S0
