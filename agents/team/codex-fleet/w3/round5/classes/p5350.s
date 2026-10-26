# n=5 model=out iset=I1 prefix14_class=5350
cmp P2, P1
mov S1, P1
cmovle S1, P2
cmovg P1, P2
mov S0, P3
cmp P0, P3
cmovg P3, P0
cmovle S0, P0
cmp S0, S1
cmovle P0, S0
cmovl S0, S1
cmovle S1, P0
cmp P3, P1
mov S1, P1
