# n=5 model=out iset=I1 prefix14_class=10504
mov S0, P3
mov S2, P1
cmp P2, S2
cmovle P1, P2
cmovge S2, P2
cmp S0, P0
mov P2, P1
cmovle S0, P0
cmovge P3, P0
cmp S2, S0
cmovle S1, S2
cmovle S2, S0
cmovl S0, S1
mov S2, S0
