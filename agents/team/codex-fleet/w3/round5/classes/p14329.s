# n=5 model=out iset=I1 prefix14_class=14329
mov S2, P2
cmp S2, P3
cmovl S2, P3
cmovg P2, P3
cmp P0, P1
mov S1, P2
cmovge P3, P1
cmovge P1, P0
cmovge P0, P3
cmp P2, P0
cmovle S1, P0
mov S0, S2
cmovl P0, P2
cmp S2, P1
