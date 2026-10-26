# n=5 model=out iset=I1 prefix14_class=9077
cmp P0, P2
cmovle S2, P0
cmovle P0, P2
mov S0, P0
cmovle P2, S2
cmp P3, P1
mov S1, P3
cmovge S1, P1
cmovl P3, P1
mov P1, S1
cmp P2, S1
cmovge S1, P2
cmovge P2, P1
cmp P3, P0
