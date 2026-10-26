# n=5 model=out iset=I1 prefix14_class=4473
cmp P2, P0
mov S0, P2
cmovg S0, P0
cmovle P2, P0
mov S2, P3
cmp P3, P1
cmovle S2, P1
cmovle P1, P3
cmp P2, S2
mov S1, S2
cmovge S2, P2
cmovl S1, P2
cmp S0, P1
cmovg P0, S0
