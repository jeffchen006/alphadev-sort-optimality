# n=5 model=out iset=I1 prefix14_class=7157
mov S0, P3
cmp P3, P1
cmovge P3, P1
cmovle S0, P1
cmp P0, P2
cmovle S2, P2
cmovl P2, P0
mov P1, P3
cmovl P0, S2
cmp P3, P2
cmovle P3, P2
cmovg P1, P2
cmp S0, P0
cmovge P1, P0
