# n=5 model=out iset=I1 prefix14_class=12331
mov S0, P3
cmp P0, P2
cmovle S2, P2
cmovle P2, P0
cmovl P0, S2
cmp S0, P1
cmovle S0, P1
cmovge P3, P1
mov P1, P2
cmp P2, P3
cmovl P2, P3
cmovg P1, P3
cmp P0, S0
cmovle S2, P0
