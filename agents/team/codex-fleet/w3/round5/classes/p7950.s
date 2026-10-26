# n=5 model=out iset=I1 prefix14_class=7950
cmp P2, P1
cmovle S1, P2
cmovge S1, P1
cmovl P2, P1
cmp P0, P3
cmovge S2, P0
cmovg P0, P3
cmovge P3, S2
mov S0, S1
cmp S0, P0
cmovle S0, P0
cmovge S1, P0
mov S1, P2
cmp S1, P3
