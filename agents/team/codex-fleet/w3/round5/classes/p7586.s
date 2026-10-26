# n=5 model=out iset=I1 prefix14_class=7586
cmp P2, P0
mov S0, P0
cmovg P0, P2
cmovle S0, P2
cmp P1, P3
cmovg S1, P3
cmovle S1, P1
cmovle P1, P3
cmp S0, S1
cmovle P2, S0
cmovl S0, S1
cmovl S1, P2
cmp P1, P0
cmovle P2, P0
