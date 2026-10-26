# n=5 model=out iset=I1 prefix14_class=12064
cmp P2, P0
mov S1, P2
cmovl S1, P0
cmovl P0, P2
cmp P3, P1
cmovge P2, P1
cmovg P1, P3
cmovg P3, P2
mov S0, P3
cmp P0, S0
cmovge P3, P0
cmovle S0, P0
mov S2, S1
cmp S1, P1
