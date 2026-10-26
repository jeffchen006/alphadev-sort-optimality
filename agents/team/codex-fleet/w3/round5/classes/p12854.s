# n=5 model=out iset=I1 prefix14_class=12854
cmp P0, P2
mov S2, P0
cmovle S2, P2
cmovle P2, P0
cmp P1, P3
mov S0, P1
cmovg P1, P3
mov S1, P2
cmovle S0, P3
cmp S1, P1
cmovle P2, P1
cmovl P1, S1
cmp S2, S0
cmovg P0, S0
