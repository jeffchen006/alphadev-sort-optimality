# n=5 model=out iset=I1 prefix14_class=10655
cmp P1, P0
cmovle S1, P0
cmovle P0, P1
cmovle P1, S1
cmp P3, P2
cmovg S0, P2
mov S2, P1
cmovg P2, P3
cmovg P3, S0
cmp P1, P2
cmovg P1, P2
cmovg P2, S2
cmp P3, P0
cmovl S0, P3
