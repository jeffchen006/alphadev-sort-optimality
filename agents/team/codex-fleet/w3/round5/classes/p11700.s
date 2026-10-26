# n=5 model=out iset=I1 prefix14_class=11700
cmp P1, P0
mov S0, P3
cmovle S2, P1
cmovle P1, P0
cmovl P0, S2
cmp P2, P3
cmovg S0, P2
cmovle P3, P2
cmp P1, S0
mov P2, S0
cmovl S0, P1
cmovl P1, P2
cmp P3, P0
cmovle P1, P0
