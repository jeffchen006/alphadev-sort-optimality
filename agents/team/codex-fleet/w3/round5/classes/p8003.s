# n=5 model=out iset=I1 prefix14_class=8003
cmp P1, P3
mov S2, P0
cmovge S0, P3
cmovge P3, P1
cmovge P1, S0
cmp S2, P2
cmovg S2, P2
cmovle P0, P2
cmp S2, P1
cmovg S1, S2
cmovle S1, P1
cmovle P1, S2
cmp P0, P3
cmovl P2, P0
