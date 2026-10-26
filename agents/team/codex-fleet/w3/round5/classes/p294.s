# n=5 model=out iset=I1 prefix14_class=294
cmp P3, P1
mov S2, P0
cmovge S1, P3
cmovge P3, P1
cmovge P1, S1
cmp P2, P0
cmovge S2, P2
cmovl P0, P2
cmp P3, P0
cmovle S1, P0
cmovle P0, P3
cmovle P3, S1
cmp P1, S2
mov S0, S2
