# n=5 model=out iset=I1 prefix14_class=5351
cmp P2, P1
mov S0, P1
cmovle S0, P2
cmovg P1, P2
mov S1, P3
cmp P0, P3
cmovg P3, P0
cmovl S1, P0
cmp S1, S0
cmovle P0, S1
cmovle S1, S0
cmovle S0, P0
cmp P3, P1
cmovg S2, P1
