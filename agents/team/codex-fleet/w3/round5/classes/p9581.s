# n=5 model=out iset=I1 prefix14_class=9581
cmp P3, P0
cmovle S0, P3
cmovl P3, P0
mov S2, P1
cmovl P0, S0
cmp P2, P1
cmovge S2, P2
cmovge P2, P1
mov P1, P3
cmp S2, P3
cmovl P1, S2
cmovge P3, S2
cmp P2, P0
cmovg S1, P2
