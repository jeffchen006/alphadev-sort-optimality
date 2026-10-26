# n=5 model=out iset=I1 prefix14_class=6794
mov S2, P2
cmp S2, P3
cmovl P2, P3
cmovl P3, S2
mov S0, P1
cmp S0, P0
cmovle P1, P0
cmovge S0, P0
cmp P1, P2
cmovg S1, P2
cmovge P2, P1
cmovle S1, P1
cmp P3, S0
cmovle P1, P3
