# n=5 model=out iset=I1 prefix14_class=9141
mov S0, P3
cmp P2, S0
cmovl S0, P2
cmovg P3, P2
mov P2, S0
cmp P0, P1
cmovle S2, P1
cmovle P1, P0
cmovl P0, S2
cmp P2, P1
cmovge P2, P1
cmovl S0, P1
cmovg P1, S0
cmp P0, P3
