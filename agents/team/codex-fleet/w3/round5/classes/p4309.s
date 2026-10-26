# n=5 model=out iset=I1 prefix14_class=4309
mov S2, P1
cmp S2, P3
mov S1, P0
cmovge P1, P3
cmovl S2, P3
cmp P0, P2
cmovle P0, P2
cmovge S1, P2
cmp P1, S1
cmovle S0, P1
cmovle P1, S1
cmovl S1, S0
mov P2, S2
cmp P0, S2
