# n=5 model=out iset=I1 prefix14_class=11294
cmp P3, P0
mov S2, P1
mov S1, P0
cmovle P0, P3
cmovge S1, P3
cmp S2, P2
cmovle S2, P2
cmovl P2, P1
cmp S1, S2
cmovge P3, S1
cmovge S1, S2
cmovge S2, P3
mov S2, P0
mov S0, S1
