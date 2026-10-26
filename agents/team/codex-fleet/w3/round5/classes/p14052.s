# n=5 model=out iset=I1 prefix14_class=14052
cmp P2, P3
mov S2, P3
cmovg P3, P2
cmovle S2, P2
cmp P1, P0
mov S0, P1
cmovge S0, P0
cmovl P1, P0
cmp P3, P1
cmovge S1, P3
cmovg P3, P1
mov P2, S0
cmovg P1, S1
cmp S2, S0
