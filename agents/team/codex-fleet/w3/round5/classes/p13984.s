# n=5 model=out iset=I1 prefix14_class=13984
mov S2, P1
cmp P1, P3
cmovle P1, P3
cmovl P3, S2
cmovle S2, P1
cmp P2, P0
cmovge S0, P0
cmovge P0, P2
cmovg P2, S0
mov S1, P3
cmp P0, P1
cmovge P1, P0
cmovle S2, P0
mov P0, S2
