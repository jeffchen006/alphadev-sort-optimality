# n=5 model=out iset=I1 prefix14_class=11302
cmp P0, P1
mov S2, P2
mov S1, P0
cmovle S1, P1
cmovl P1, P0
cmp P2, P3
cmovle S2, P3
cmovl P3, P2
cmp S1, S2
cmovge S0, S1
cmovg S1, S2
cmovg S2, S0
mov P2, S1
cmp P1, P3
