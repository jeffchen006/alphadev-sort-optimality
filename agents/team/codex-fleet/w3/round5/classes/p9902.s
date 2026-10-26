# n=5 model=out iset=I1 prefix14_class=9902
mov S2, P2
cmp P0, P1
cmovge S0, P0
cmovg P0, P1
cmovge P1, S0
cmp S2, P3
mov S1, P1
cmovle S2, P3
cmovl P3, P2
cmp S2, P1
cmovle S1, S2
cmovle S2, P1
mov P2, P3
mov S2, S1
