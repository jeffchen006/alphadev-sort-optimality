# n=5 model=out iset=I1 prefix14_class=9018
cmp P1, P0
mov S0, P0
cmovl S0, P1
mov S2, P3
cmovle P1, P0
cmp P2, S2
cmovle P3, P2
cmovle P2, S2
cmp P1, P2
cmovge P0, P2
cmovg P2, P1
cmovg P1, P0
cmp P3, S0
cmovl P2, S0
