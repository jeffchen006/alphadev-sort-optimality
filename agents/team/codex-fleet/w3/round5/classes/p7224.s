# n=5 model=out iset=I1 prefix14_class=7224
cmp P2, P1
mov S0, P2
cmovge P2, P1
cmovle S0, P1
cmp P0, P3
mov P1, P3
mov S2, S0
cmovge P3, P0
cmovge P0, P1
cmp P0, P2
cmovl S1, P2
cmovl P2, P0
cmovl P0, S1
cmp P3, S2
