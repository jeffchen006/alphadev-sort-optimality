# n=5 model=out iset=I1 prefix14_class=8639
mov S2, P1
cmp P0, S2
cmovle P1, P0
mov S0, P3
cmovg S2, P0
cmp S0, P2
cmovl S0, P2
cmovg P3, P2
cmp S2, S0
mov S1, S0
cmovl S0, S2
cmovg S1, S2
cmp P1, P3
cmovle S1, P1
