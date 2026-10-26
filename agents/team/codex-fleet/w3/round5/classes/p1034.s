# n=5 model=out iset=I1 prefix14_class=1034
mov S0, P0
mov S1, P3
cmp S1, P2
cmovl P3, P2
cmovl P2, S1
cmp P0, P1
cmovge P0, P1
cmovg P1, S0
cmp P1, P3
cmovle S2, P3
cmovge S2, P1
mov S0, P2
cmovg P1, P3
cmp S0, P0
