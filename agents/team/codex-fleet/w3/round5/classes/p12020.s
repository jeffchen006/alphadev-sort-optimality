# n=5 model=out iset=I1 prefix14_class=12020
cmp P0, P1
mov S2, P0
cmovge S2, P1
cmovge P1, P0
mov P0, P2
cmp P2, P3
mov S0, P1
cmovle P2, P3
cmovge P0, P3
cmp P0, S2
cmovle P3, P0
cmovl P0, S2
mov S1, P0
cmovle S2, P3
