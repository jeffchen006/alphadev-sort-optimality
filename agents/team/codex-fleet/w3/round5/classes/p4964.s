# n=5 model=out iset=I1 prefix14_class=4964
cmp P0, P1
mov S0, P0
cmovg S0, P1
cmovle P0, P1
cmp P3, P2
mov P1, P0
mov S1, P3
cmovle P3, P2
cmovl P2, S1
cmp P2, S0
cmovg S1, P2
cmovg P2, S0
cmovg S0, S1
cmp P0, P3
