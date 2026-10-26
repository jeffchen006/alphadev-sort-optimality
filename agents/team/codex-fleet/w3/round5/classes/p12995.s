# n=5 model=out iset=I1 prefix14_class=12995
mov S2, P3
mov S0, P2
cmp P2, P1
cmovle P2, P1
cmovl P1, S0
cmp P0, P3
cmovl P3, P0
cmovle P0, S2
cmp P3, P1
cmovge S0, P1
cmovge P1, P3
mov S1, P0
cmovg P3, S0
cmp P0, P2
