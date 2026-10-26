# n=5 model=out iset=I1 prefix14_class=3625
cmp P1, P2
cmovle S0, P1
cmovle P1, P2
cmovl P2, S0
mov S1, P3
cmp P0, P3
cmovle P3, P0
cmovle P0, S1
mov S1, P3
cmp P2, P3
mov S2, P0
cmovle S1, P2
cmovg P3, P2
cmp S2, P1
