# n=5 model=out iset=I1 prefix14_class=8352
mov S0, P3
cmp P0, P3
cmovl P3, P0
mov S2, P2
cmovle P0, S0
cmp P1, P2
cmovge P2, P1
cmovge P1, S2
cmp P1, P3
cmovge S1, P1
cmovle S1, P3
cmovge P1, P3
mov P1, S1
mov P3, P2
