# n=5 model=out iset=I1 prefix14_class=10895
mov S1, P1
cmp P2, P3
cmovle S2, P2
cmovle P2, P3
cmovle P3, S2
cmp P1, P0
cmovge P1, P0
cmovl S1, P0
cmp S1, P2
cmovg S0, P2
cmovge P2, S1
cmovle S0, S1
cmp P3, P1
cmovle S1, P1
