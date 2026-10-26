# n=5 model=out iset=I1 prefix14_class=13649
cmp P3, P2
cmovle S0, P3
cmovge S0, P2
cmovl P3, P2
cmp P0, P1
mov S1, P0
mov S2, P3
cmovge S1, P1
cmovge P1, P0
cmp S2, P1
cmovge S2, P1
cmovl P3, P1
cmp S1, S0
cmovg P0, S0
