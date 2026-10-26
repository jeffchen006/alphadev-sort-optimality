# n=5 model=out iset=I1 prefix14_class=8929
cmp P3, P2
mov S0, P2
cmovl P2, P3
cmovl P3, S0
cmp P0, P1
mov S0, P1
cmovl S0, P0
cmovl P0, P1
cmp P3, P0
cmovle P1, P0
cmovle P0, P3
mov S2, S0
cmovle P3, P1
cmp P2, S2
