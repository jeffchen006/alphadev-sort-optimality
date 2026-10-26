# n=5 model=out iset=I1 prefix14_class=7233
cmp P3, P1
mov S2, P3
cmovle S2, P1
cmovge P3, P1
cmp P0, P2
mov P1, P2
cmovge P2, P0
cmovg P0, P1
cmp P3, P0
cmovle S0, P0
mov P1, P2
cmovl P0, P3
cmovle P3, S0
cmp S2, P1
