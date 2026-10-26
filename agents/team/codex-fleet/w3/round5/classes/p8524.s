# n=5 model=out iset=I1 prefix14_class=8524
mov S0, P3
cmp P3, P2
cmovle P3, P2
mov S2, P1
cmovl P2, S0
cmp P0, P1
cmovge S2, P0
cmovl P1, P0
cmp P3, S2
cmovge P0, S2
cmovge S2, P3
cmovg P3, P0
cmp P1, P2
mov S2, P1
