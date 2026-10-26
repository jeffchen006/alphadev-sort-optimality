# n=5 model=out iset=I1 prefix14_class=6516
mov S0, P2
cmp P2, P1
cmovg P2, P1
cmovg P1, S0
cmp P3, P0
mov S0, P0
cmovle S0, P3
cmovl P3, P0
cmp P3, P1
cmovle P0, P3
mov S1, P2
cmovle P3, P1
cmovl P1, P0
cmp S0, P2
