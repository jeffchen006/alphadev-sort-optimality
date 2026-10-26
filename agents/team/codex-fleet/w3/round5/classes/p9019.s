# n=5 model=out iset=I1 prefix14_class=9019
cmp P1, P0
mov S2, P0
cmovl S2, P1
mov S0, P2
cmovle P1, P0
cmp P3, S0
cmovle P2, P3
cmovle P3, S0
cmp P1, P3
cmovge P0, P3
cmovg P3, P1
cmovg P1, P0
cmp P2, S2
cmovl P3, S2
