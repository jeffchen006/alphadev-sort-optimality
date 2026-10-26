# n=5 model=out iset=I1 prefix14_class=1855
mov S1, P1
cmp P3, P2
cmovge S2, P2
cmovl S2, P3
cmovg P2, P3
cmp P0, P1
cmovge P1, P0
cmovg P0, S1
mov S0, P1
cmp S0, P2
cmovle S0, P2
cmovl P2, P1
cmp S2, P0
mov P1, P2
