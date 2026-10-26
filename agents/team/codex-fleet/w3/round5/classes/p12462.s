# n=5 model=out iset=I1 prefix14_class=12462
mov S2, P0
cmp P3, P1
cmovl S0, P3
cmovle P3, P1
cmovl P1, S0
cmp P0, P2
cmovl P0, P2
cmovg S2, P2
mov S1, S2
cmp P1, S2
cmovle S1, P1
cmovg S2, P1
cmp P3, P0
cmovle P1, S2
