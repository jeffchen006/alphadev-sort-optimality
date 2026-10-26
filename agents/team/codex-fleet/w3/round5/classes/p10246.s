# n=5 model=out iset=I1 prefix14_class=10246
cmp P1, P0
cmovle S2, P0
cmovl P0, P1
cmovge S2, P1
cmp P2, P3
cmovle S0, P3
mov P1, S2
cmovl P3, P2
cmovl P2, S0
cmp S2, P2
cmovge P1, P2
cmovg P2, S2
mov S2, P0
cmp P3, S2
