# n=5 model=out iset=I1 prefix14_class=11161
mov S2, P1
cmp P1, P3
mov S1, P2
cmovle P1, P3
cmovle P3, S2
cmp P2, P0
cmovle S1, P0
cmovg P2, P0
cmp S1, P1
mov S0, S1
cmovl S0, P1
cmovg S1, P1
cmp P3, P2
cmovle S0, P3
