# n=5 model=out iset=I1 prefix14_class=14399
cmp P0, P2
mov S0, P2
cmovle S0, P0
cmovl P0, P2
mov S2, P3
cmp S2, P1
cmovle S2, P1
cmovg P3, P1
cmp P3, S0
cmovle S1, S0
cmovle S0, P3
mov S0, S2
cmovle P3, S1
cmp S2, P0
