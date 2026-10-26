# n=5 model=out iset=I1 prefix14_class=5452
cmp P3, P0
cmovle S2, P3
cmovle P3, P0
cmovg S2, P0
mov S0, S2
cmp P2, P1
cmovg P0, P1
cmovg P1, P2
cmovg P2, P0
cmp P2, S2
cmovl S0, P2
cmovle P2, S2
mov S1, P1
cmp P1, P3
