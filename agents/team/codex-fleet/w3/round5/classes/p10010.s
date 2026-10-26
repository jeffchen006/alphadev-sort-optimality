# n=5 model=out iset=I1 prefix14_class=10010
cmp P3, P0
cmovge S1, P0
cmovge P0, P3
cmovle S1, P3
mov S2, S1
cmp P2, P1
cmovge P3, P1
cmovg P1, P2
mov S0, P1
cmovge P2, P3
cmp P1, P0
cmovl P1, P0
cmovl P0, S0
cmp S1, P2
