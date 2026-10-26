# n=5 model=out iset=I1 prefix14_class=8456
cmp P1, P3
mov S0, P3
cmovge S0, P1
cmovle P3, P1
cmp P2, P0
cmovle S2, P2
cmovl P2, P0
cmovg S2, P0
cmp P2, S0
mov P1, P2
cmovl P1, S0
cmovge P2, S0
cmp P3, S2
cmovg S1, P3
