# n=5 model=out iset=I1 prefix14_class=2449
mov S2, P2
cmp S2, P0
cmovge P2, P0
cmovl S2, P0
mov S0, P3
cmp P1, P3
cmovge P3, P1
cmovge P1, S0
cmovge S0, P3
cmp P3, S2
cmovle P3, S2
cmovle S2, S0
cmp P1, P2
cmovle S0, P2
