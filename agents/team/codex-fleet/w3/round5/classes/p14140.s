# n=5 model=out iset=I1 prefix14_class=14140
cmp P3, P2
cmovle S2, P2
cmovl P2, P3
cmovle P3, S2
mov S0, P0
cmp P1, P0
cmovg S0, P1
cmovg P1, P0
cmp P3, S0
mov S1, P3
cmovl S1, S0
cmovl S0, P3
cmp P1, P2
cmovg S1, P2
