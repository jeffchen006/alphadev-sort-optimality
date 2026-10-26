# n=5 model=out iset=I1 prefix14_class=3000
mov S2, P2
cmp P1, P0
cmovle S0, P1
cmovl P1, P0
cmovle P0, S0
mov S1, P1
cmp P2, P3
cmovg S2, P3
cmovg P3, P2
cmp P1, P3
cmovg S1, P3
cmovg P3, P1
cmp P0, S2
cmovl P1, P0
