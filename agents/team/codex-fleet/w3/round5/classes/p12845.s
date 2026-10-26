# n=5 model=out iset=I1 prefix14_class=12845
cmp P1, P3
cmovge S2, P1
cmovle S2, P3
cmovge P1, P3
mov S1, P2
cmp P0, S1
cmovle P2, P0
mov S0, S2
cmovg S1, P0
cmp P2, P1
cmovl P3, P2
cmovle P2, P1
cmovl P1, P3
mov P0, P2
