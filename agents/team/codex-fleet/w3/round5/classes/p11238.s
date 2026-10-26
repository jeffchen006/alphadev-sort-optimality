# n=5 model=out iset=I1 prefix14_class=11238
cmp P2, P3
mov S1, P2
cmovg P2, P3
cmovg P3, S1
cmp P1, P0
cmovl S0, P0
cmovle P0, P1
cmovl P1, S0
mov S2, P3
cmp P1, S2
cmovge S2, P1
cmovge P1, P3
mov S2, P2
cmp P2, P0
