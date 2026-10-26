# n=5 model=out iset=I1 prefix14_class=5339
cmp P2, P1
mov S2, P1
cmovle S2, P2
cmovge P1, P2
cmp P0, P3
mov P2, P3
cmovge P3, P0
cmovl P2, P0
cmp P2, S2
cmovle S0, P2
cmovle P2, S2
cmovle S2, S0
mov P0, P3
cmp P1, P0
