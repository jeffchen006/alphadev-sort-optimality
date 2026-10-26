# n=5 model=out iset=I1 prefix14_class=5203
cmp P2, P1
mov S2, P2
cmovle S2, P1
cmovge P2, P1
cmp P3, P0
mov S1, P0
cmovl P0, P3
cmovl P3, S1
cmp P2, P0
cmovge S0, P2
cmovg P2, P0
cmovge P0, S0
mov P2, P3
cmp S2, P3
