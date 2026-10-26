# n=5 model=out iset=I1 prefix14_class=6764
mov S2, P2
cmp P1, P0
cmovle S1, P1
cmovle P1, P0
cmovg S1, P0
cmp P3, S2
cmovge S2, P3
cmovl P2, P3
mov P3, P2
cmp S2, P1
cmovge S0, S2
cmovg S2, P1
cmovge P1, S0
cmp S1, P2
