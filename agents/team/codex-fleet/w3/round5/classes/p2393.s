# n=5 model=out iset=I1 prefix14_class=2393
cmp P3, P0
mov S0, P3
cmovg P3, P0
cmovge P0, S0
mov S1, P1
cmp P1, P2
cmovle S1, P2
cmovl P2, P1
cmp P0, S1
cmovl S0, P0
cmovl P0, S1
cmovl S1, S0
mov P0, P3
cmp P0, P2
