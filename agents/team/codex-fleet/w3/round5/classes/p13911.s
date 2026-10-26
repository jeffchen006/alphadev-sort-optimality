# n=5 model=out iset=I1 prefix14_class=13911
cmp P1, P2
cmovle S2, P1
cmovle P1, P2
cmovl P2, S2
mov S0, P3
cmp P0, P3
cmovge P3, P0
cmovge P0, S0
cmp P1, P3
cmovge S0, P3
cmovle S0, P1
mov S1, S0
cmovge P3, P1
mov P3, P0
