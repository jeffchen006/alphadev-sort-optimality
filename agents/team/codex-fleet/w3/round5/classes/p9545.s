# n=5 model=out iset=I1 prefix14_class=9545
mov S2, P3
cmp P2, P3
cmovg P3, P2
cmovge P2, S2
mov S1, P0
cmp S1, P1
cmovge P0, P1
cmovl S1, P1
cmp P0, P2
cmovle S0, P0
cmovl P0, P2
cmovl P2, S0
cmp P3, S1
mov P1, S1
