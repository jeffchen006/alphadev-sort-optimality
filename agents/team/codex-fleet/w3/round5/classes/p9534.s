# n=5 model=out iset=I1 prefix14_class=9534
cmp P0, P2
cmovle S0, P0
cmovl P0, P2
cmovge S0, P2
cmp P1, P3
cmovg P2, P1
cmovge P1, P3
mov S1, S0
cmovg P3, P2
cmp S1, P1
cmovge S1, P1
cmovle S0, P1
cmp P0, P3
mov S2, P0
