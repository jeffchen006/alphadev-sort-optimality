# n=5 model=out iset=I1 prefix14_class=12482
mov S1, P0
cmp P1, S1
cmovl S1, P1
mov S2, P3
cmovge P0, P1
cmp P2, S2
cmovge P3, P2
mov P1, P3
cmovg P2, S2
cmp S1, P2
cmovle S0, P2
cmovl P2, S1
cmovl S1, S0
cmp P3, P0
