# n=5 model=out iset=I1 prefix14_class=1215
mov S1, P2
mov S0, P1
cmp S0, P3
cmovl P1, P3
cmovl P3, S0
cmp S1, P0
cmovge P2, P0
cmovle S1, P0
cmp P1, S1
cmovge S0, P1
mov S2, P3
cmovge P1, S1
cmovge S1, S0
cmp P3, P2
