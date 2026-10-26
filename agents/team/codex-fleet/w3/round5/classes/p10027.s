# n=5 model=out iset=I1 prefix14_class=10027
mov S0, P3
cmp P3, P1
cmovg P3, P1
cmovle S0, P1
mov P1, P2
cmp P1, P0
cmovge P2, P0
cmovge P0, P1
cmovge P1, P2
cmp P0, S0
cmovle S2, P0
cmovl P0, S0
cmovl S0, S2
cmp P3, P2
