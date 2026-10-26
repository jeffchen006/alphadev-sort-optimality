# n=5 model=out iset=I1 prefix14_class=9815
cmp P0, P1
cmovl S0, P1
cmovge S0, P0
cmovge P0, P1
cmp P3, P2
cmovle S2, P2
cmovl P2, P3
mov P1, S0
cmovle P3, S2
cmp P3, S0
cmovge P1, P3
cmovg P3, S0
cmp P2, P0
cmovge P1, P2
