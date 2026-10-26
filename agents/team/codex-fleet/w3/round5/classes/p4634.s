# n=5 model=out iset=I1 prefix14_class=4634
mov S0, P3
mov S1, P0
cmp P2, S1
cmovl P0, P2
cmovg S1, P2
cmp P1, S0
cmovl P3, P1
cmovle P1, S0
cmp P1, S1
mov S2, P1
cmovg S2, S1
cmovl P1, S1
cmp P0, P3
cmovl P2, P3
