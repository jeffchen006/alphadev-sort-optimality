# n=5 model=out iset=I1 prefix14_class=7966
cmp P3, P1
mov S0, P1
mov S2, P0
cmovg P1, P3
cmovge P3, S0
cmp P0, P2
cmovg P0, P2
cmovl S2, P2
cmp P0, P3
mov S1, P1
cmovl P2, P0
cmovle P0, P3
cmovl P3, P2
cmp P1, S2
