# n=5 model=out iset=I1 prefix14_class=10926
cmp P1, P2
cmovle S1, P2
cmovle P2, P1
mov S0, P3
cmovle P1, S1
mov S2, P1
cmp P0, S0
cmovg S0, P0
cmovle P3, P0
cmp S0, P1
cmovle P1, S0
cmovg S2, S0
cmp P2, P3
cmovl S0, P3
