# n=5 model=out iset=I1 prefix14_class=9133
mov S1, P0
mov S0, P3
cmp S0, P2
cmovge S0, P2
cmovl P3, P2
cmp P0, P1
mov S2, S0
cmovg P0, P1
cmovge P1, S1
cmp P0, S2
cmovle S2, P0
cmovl P0, S0
cmp P3, P1
cmovge S1, P1
