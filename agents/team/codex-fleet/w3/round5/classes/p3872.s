# n=5 model=out iset=I1 prefix14_class=3872
cmp P2, P1
mov S0, P2
cmovg S0, P1
mov S2, S0
cmovg P1, P2
mov S1, P3
cmp S1, P0
cmovle S1, P0
cmovle P0, P3
cmp S0, P0
cmovl S2, P0
cmovle P0, S0
cmp P1, S1
cmovle S0, S1
