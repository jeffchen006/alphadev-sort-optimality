# n=5 model=out iset=I1 prefix14_class=4969
mov S2, P0
cmp P0, P2
cmovge P0, P2
mov S1, P3
mov S0, P0
cmovle S2, P2
cmp P3, P1
cmovle S1, P1
cmovge P3, P1
cmp P3, P0
cmovl S0, P3
cmovle P3, P0
cmp S1, S2
cmovle P1, S2
