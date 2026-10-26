# n=5 model=out iset=I1 prefix14_class=3695
mov S1, P2
cmp P0, P2
cmovg S1, P0
cmovl P2, P0
mov S0, P1
cmp P1, P3
cmovl S0, P3
mov P0, P2
cmovl P3, P1
cmp P2, P3
cmovl P0, P3
cmovle P3, P2
mov P2, P0
mov P3, S1
