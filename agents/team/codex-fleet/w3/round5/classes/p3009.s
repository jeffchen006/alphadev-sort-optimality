# n=5 model=out iset=I1 prefix14_class=3009
cmp P3, P0
cmovle S2, P3
cmovl P3, P0
cmovl P0, S2
cmp P1, P2
mov S0, P1
mov S1, P3
cmovge P1, P2
cmovg P2, S0
cmp S1, P2
cmovge S1, P2
cmovge P2, P3
cmp P1, P0
mov P3, P1
