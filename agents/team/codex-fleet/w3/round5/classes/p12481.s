# n=5 model=out iset=I1 prefix14_class=12481
mov S2, P0
mov S1, P3
cmp P1, S1
cmovg P3, P1
cmovle S1, P1
cmp P2, P0
cmovge P0, P2
mov P1, P0
cmovg P2, S2
cmp S1, P2
cmovle S0, P2
cmovl P2, S1
cmovl S1, S0
cmp P1, P3
