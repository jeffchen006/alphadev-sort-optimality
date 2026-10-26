# n=5 model=out iset=I1 prefix14_class=14100
mov S1, P2
cmp P0, P2
cmovg S1, P0
mov S0, P3
cmovg P0, P2
cmovle P2, P0
cmp S0, P1
cmovl S0, P1
cmovg P3, P1
cmp S0, S1
cmovle P1, S1
cmovle S1, S0
cmovl S0, P1
cmp P3, P2
