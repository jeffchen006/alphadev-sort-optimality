# n=5 model=out iset=I1 prefix14_class=5433
mov S1, P0
cmp P0, P2
cmovle S1, P2
cmovge P0, P2
mov S0, P3
cmp S0, P1
cmovl P3, P1
mov S2, P0
cmovge S0, P1
cmp S0, S2
cmovle S2, S0
cmovg P0, S0
cmp P3, S1
mov S2, P3
