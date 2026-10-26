# n=5 model=out iset=I1 prefix14_class=7722
mov S2, P2
cmp P2, P1
cmovge P2, P1
cmovle S2, P1
cmp P0, P3
mov S0, P0
cmovl S0, P3
cmovge P0, P3
cmp P2, P0
cmovl S1, P0
cmovl P0, P2
cmovl P2, S1
mov P0, P2
mov S1, S0
