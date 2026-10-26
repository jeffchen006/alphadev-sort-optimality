# n=5 model=out iset=I1 prefix14_class=3863
cmp P3, P0
cmovle S0, P3
cmovg S0, P0
cmovge P0, P3
mov S2, P2
mov S1, S0
cmp P2, P1
cmovle P2, P1
cmovl P1, S2
cmp S0, P1
cmovle S1, P1
cmovl P1, S0
cmovle S0, S1
mov P1, P0
