# n=5 model=out iset=I1 prefix14_class=12512
mov S0, P2
cmp P2, P3
cmovle S0, P3
mov S2, P1
cmovl P3, P2
cmp P0, S2
cmovl S2, P0
cmovge P1, P0
cmp P3, S2
cmovl S1, P3
mov P2, P1
cmovl P3, S2
cmovl S2, S1
cmp P2, S0
