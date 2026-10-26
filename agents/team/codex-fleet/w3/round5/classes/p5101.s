# n=5 model=out iset=I1 prefix14_class=5101
cmp P3, P2
mov S0, P3
cmovg P3, P2
cmovle S0, P2
cmp P0, P1
cmovg S2, P0
cmovg P0, P1
mov S1, P3
cmovle S2, P1
cmp S1, P0
cmovl S1, P0
cmovl P0, P3
cmp S2, S0
cmovle P1, S2
