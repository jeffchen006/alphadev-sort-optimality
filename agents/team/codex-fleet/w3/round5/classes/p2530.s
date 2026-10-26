# n=5 model=out iset=I1 prefix14_class=2530
mov S1, P0
mov S0, P3
cmp P2, P3
cmovle S0, P2
cmovl P2, P3
cmp S1, P1
cmovl S1, P1
cmovl P1, P0
mov S2, P2
cmp P2, S1
cmovl S2, S1
cmovge P2, S1
mov S2, P1
mov S1, P2
