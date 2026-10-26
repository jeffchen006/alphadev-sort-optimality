# n=5 model=out iset=I1 prefix14_class=464
mov S0, P2
mov S2, P3
cmp P3, P0
cmovl P3, P0
cmovl P0, S2
cmp S0, P1
cmovge P2, P1
cmovg P1, S0
mov S2, P1
cmp P0, P2
cmovle S1, P2
cmovle P2, P0
cmovle P0, S1
cmp P1, P3
