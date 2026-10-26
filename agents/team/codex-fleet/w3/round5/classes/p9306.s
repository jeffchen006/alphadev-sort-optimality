# n=5 model=out iset=I1 prefix14_class=9306
mov S0, P0
cmp P0, P3
cmovg S0, P3
cmovle P0, P3
mov S1, P1
cmp P2, P1
cmovl P1, P2
cmovl P2, S1
mov P3, S0
cmp P1, S0
cmovl P3, P1
cmovg S0, P1
cmp P0, P2
cmovl S1, P2
