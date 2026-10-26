# n=5 model=out iset=I1 prefix14_class=10144
cmp P2, P0
mov S2, P0
cmovle S2, P2
cmovge P0, P2
cmp P3, P1
cmovl P2, P3
cmovl P3, P1
mov S0, P0
cmovl P1, P2
cmp P3, P0
cmovg P0, P3
cmovl S0, P3
mov P3, S2
mov P0, S0
