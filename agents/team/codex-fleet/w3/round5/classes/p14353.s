# n=5 model=out iset=I1 prefix14_class=14353
mov S0, P1
cmp P0, P3
cmovl S2, P0
cmovle P0, P3
cmovl P3, S2
cmp P1, P2
cmovl P1, P2
mov S1, P3
cmovle P2, S0
cmp P2, S1
cmovg S1, P2
cmovl P3, P2
mov P2, P1
mov P3, S1
