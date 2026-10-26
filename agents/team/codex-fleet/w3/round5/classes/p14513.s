# n=5 model=out iset=I1 prefix14_class=14513
cmp P3, P0
cmovle S1, P0
cmovle P0, P3
cmovl P3, S1
mov S2, P2
cmp P1, S2
cmovle P2, P1
cmovge S2, P1
cmp P0, P2
cmovge S0, P0
cmovle S0, P2
cmovle P2, P0
cmp P3, S2
cmovge S1, P3
