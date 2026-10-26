# n=5 model=out iset=I1 prefix14_class=91
mov S2, P1
mov S1, P2
cmp P3, S2
cmovge P1, P3
cmovge P3, S2
cmp P0, P2
cmovle P2, P0
cmovg S1, P0
cmovle P0, S1
cmp P3, P2
cmovle S0, P2
cmovge S0, P3
cmovl P2, P3
cmp S1, P1
