# n=5 model=out iset=I1 prefix14_class=5270
mov S1, P0
cmp S1, P3
cmovg S1, P3
cmovge P3, P0
mov P0, S1
mov S2, P2
cmp P1, S2
cmovge S2, P1
cmovl P2, P1
cmp S1, P2
cmovge P0, P2
cmovle S1, P2
cmp S2, P3
cmovle S0, S2
