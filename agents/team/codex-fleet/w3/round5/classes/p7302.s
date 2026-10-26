# n=5 model=out iset=I1 prefix14_class=7302
cmp P2, P1
cmovle S0, P1
cmovle P1, P2
mov S1, P0
cmovle P2, S0
cmp P3, P0
cmovl S1, P3
cmovle P3, P0
mov S2, P1
cmp P1, S1
cmovg P1, S1
mov P1, P2
cmovg S1, S2
cmp P3, P2
