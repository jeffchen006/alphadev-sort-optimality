# n=5 model=out iset=I1 prefix14_class=600
mov S1, P2
mov S2, P3
cmp S2, P1
cmovle P3, P1
cmovge S2, P1
cmovg P1, P3
cmp P2, P0
cmovg S1, P0
cmovge P0, P2
cmp P0, P3
cmovl P1, P0
cmovge P3, P0
cmp S1, S2
cmovle S0, S2
