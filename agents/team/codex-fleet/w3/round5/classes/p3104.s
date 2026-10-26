# n=5 model=out iset=I1 prefix14_class=3104
cmp P3, P1
cmovle S2, P3
mov S1, P0
cmovle P3, P1
cmovle P1, S2
cmp P2, S1
cmovl S1, P2
cmovg P0, P2
mov P2, P0
mov S0, P1
cmp P1, S1
cmovg S0, S1
cmovl P1, S1
cmp P3, P2
