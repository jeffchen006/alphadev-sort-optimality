# n=5 model=out iset=I1 prefix14_class=7995
cmp P3, P1
mov S0, P1
cmovl P1, P3
cmovge S0, P3
mov S2, P2
cmp P2, P0
mov S1, P1
cmovg P2, P0
cmovle S2, P0
cmp P2, P1
cmovle S1, P2
cmovg P1, P2
mov S1, P1
cmp S2, S0
