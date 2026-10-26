# n=5 model=out iset=I1 prefix14_class=1947
cmp P2, P0
mov S1, P2
cmovl P2, P0
cmovge S1, P0
cmp P1, P3
cmovg S2, P3
cmovge P3, P1
cmovle S2, P1
mov S0, P2
cmp P3, P2
cmovg S0, P3
cmovle P2, P3
cmp S1, S2
cmovge P0, S2
