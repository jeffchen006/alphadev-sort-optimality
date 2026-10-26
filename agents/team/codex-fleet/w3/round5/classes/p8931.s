# n=5 model=out iset=I1 prefix14_class=8931
mov S0, P1
cmp S0, P2
cmovle S0, P2
cmovg P1, P2
cmp P3, P0
cmovge P2, P0
cmovge P0, P3
mov S2, P0
cmovg P3, P2
cmp S0, P0
cmovl P0, S0
cmovl S0, S2
mov S1, P3
cmp P1, P3
