# n=5 model=out iset=I1 prefix14_class=1154
cmp P3, P0
mov S2, P2
mov S0, P3
cmovl P3, P0
cmovl P0, S0
cmp P2, P1
cmovl P2, P1
cmovg S2, P1
cmp P2, P3
mov S1, P2
cmovl S1, P3
mov P1, S2
cmovle P3, P2
mov P2, P3
