# n=5 model=out iset=I1 prefix14_class=11921
cmp P3, P2
cmovle S1, P3
cmovle P3, P2
cmovl P2, S1
mov S1, P0
cmp S1, P1
cmovle S1, P1
cmovl P1, P0
cmp P3, S1
cmovge S0, S1
cmovge S1, P3
cmovge P3, S0
mov S2, P1
mov S1, P3
