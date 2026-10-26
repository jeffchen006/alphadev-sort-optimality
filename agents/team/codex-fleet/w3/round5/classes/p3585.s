# n=5 model=out iset=I1 prefix14_class=3585
cmp P1, P2
cmovle S1, P1
cmovl P1, P2
cmovl P2, S1
mov S2, P2
mov S0, P0
cmp P3, P0
cmovg S0, P3
cmovle P0, P3
cmp P0, P2
cmovl S2, P0
mov P3, S0
cmovg P2, P0
cmp P3, P1
