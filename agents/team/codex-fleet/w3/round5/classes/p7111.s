# n=5 model=out iset=I1 prefix14_class=7111
cmp P3, P1
cmovle S2, P1
cmovle P1, P3
cmovle P3, S2
mov S0, P2
cmp S0, P0
cmovl S0, P0
cmovl P0, P2
cmp P0, P1
cmovge P2, P0
cmovge P0, P1
cmovle P2, P1
mov S1, P2
mov P1, P3
