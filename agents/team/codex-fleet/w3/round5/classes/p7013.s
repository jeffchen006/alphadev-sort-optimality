# n=5 model=out iset=I1 prefix14_class=7013
cmp P3, P1
cmovle S1, P1
mov S2, P0
cmovle P1, P3
cmovle P3, S1
cmp S2, P2
cmovle P0, P2
cmovl P2, S2
cmp P2, P1
mov S2, P2
cmovge P2, P1
cmovl S2, P1
mov P2, P3
mov S0, S2
