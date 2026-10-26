# n=5 model=out iset=I1 prefix14_class=12660
cmp P1, P2
cmovge S1, P1
cmovge P1, P2
cmovle S1, P2
cmp P0, P3
mov S2, P0
cmovge S2, P3
cmovl P0, P3
mov S0, S2
cmp P1, S2
cmovg S2, P1
cmovge P1, S0
cmp S1, P0
cmovle P1, P0
