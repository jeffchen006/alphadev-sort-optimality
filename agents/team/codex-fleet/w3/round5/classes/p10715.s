# n=5 model=out iset=I1 prefix14_class=10715
cmp P0, P2
cmovle S1, P2
mov S2, P1
cmovl P2, P0
cmovl P0, S1
cmp P3, S2
mov S0, P0
cmovl S2, P3
cmovge P1, P3
cmp P1, S0
cmovge P0, P1
cmovge P1, S0
cmp P2, S2
mov S0, P2
