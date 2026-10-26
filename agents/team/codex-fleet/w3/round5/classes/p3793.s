# n=5 model=out iset=I1 prefix14_class=3793
cmp P1, P3
mov S0, P1
cmovge P1, P3
cmovge P3, S0
cmp P0, P2
mov S0, P2
cmovle S0, P0
cmovle P0, P2
mov S2, P1
cmp S2, S0
cmovle S2, S0
cmovl S0, P1
cmp P0, P3
cmovle P1, P3
