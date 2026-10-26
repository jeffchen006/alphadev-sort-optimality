# n=5 model=out iset=I1 prefix14_class=10164
mov S2, P1
cmp S2, P0
cmovl P1, P0
mov S1, P3
cmovle P0, S2
cmp S1, P2
cmovge P3, P2
cmovg P2, S1
mov S0, P0
cmp P1, P2
cmovle S2, P2
cmovl P2, P1
cmovl P1, S2
cmp P0, P3
