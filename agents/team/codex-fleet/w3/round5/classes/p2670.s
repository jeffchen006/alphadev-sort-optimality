# n=5 model=out iset=I1 prefix14_class=2670
mov S2, P1
mov S0, P3
cmp P0, P1
cmovl P1, P0
cmovge S2, P0
cmp S0, P2
cmovge S0, P2
cmovg P2, P3
mov S1, P2
cmp S2, P2
cmovle S1, S2
cmovle S2, P2
cmp P1, S0
mov S2, S1
