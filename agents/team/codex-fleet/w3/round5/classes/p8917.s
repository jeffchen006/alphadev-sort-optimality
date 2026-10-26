# n=5 model=out iset=I1 prefix14_class=8917
cmp P2, P1
cmovl S2, P1
cmovl P1, P2
cmovl P2, S2
mov S0, P3
cmp P0, S0
cmovl P3, P0
cmovle P0, S0
cmp P0, P2
cmovle S0, P0
cmovg S0, P2
cmovle P0, P2
mov P0, P3
cmp P1, P3
