# n=5 model=out iset=I1 prefix14_class=14478
mov S1, P2
cmp P1, P2
cmovg P2, P1
mov S2, P3
cmovge P1, S1
cmp S2, P0
cmovge P3, P0
cmovle S2, P0
cmp P3, P1
cmovl S0, P1
cmovl P1, P3
cmovl P3, S0
mov P1, P2
cmp S2, P1
