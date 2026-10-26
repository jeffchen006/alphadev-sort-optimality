# n=5 model=out iset=I1 prefix14_class=14036
mov S0, P2
cmp P2, P0
mov S1, P3
cmovg P2, P0
cmovg P0, S0
cmp P3, P1
cmovge P3, P1
cmovl S1, P1
mov S2, P2
cmp P0, S1
cmovle P1, S1
cmovle S1, P0
cmovl P0, P1
cmp P2, P3
