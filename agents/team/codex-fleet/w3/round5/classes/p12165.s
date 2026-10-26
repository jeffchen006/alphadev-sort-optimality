# n=5 model=out iset=I1 prefix14_class=12165
cmp P1, P2
cmovge S2, P2
mov S0, P0
cmovg P2, P1
cmovge P1, S2
cmp S0, P3
cmovge S0, P3
cmovl P0, P3
cmp S0, P1
cmovge S1, S0
cmovge S0, P1
cmovg P1, S1
cmp P0, P2
cmovle S2, P0
