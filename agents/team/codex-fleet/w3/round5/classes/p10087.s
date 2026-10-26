# n=5 model=out iset=I1 prefix14_class=10087
mov S2, P1
mov S0, P2
cmp P3, P2
cmovle P2, P3
cmovge S0, P3
cmp P1, P0
cmovge P1, P0
cmovle S2, P0
cmp S0, S2
mov P3, S0
cmovl S0, S2
cmovg P3, S2
cmp P2, P1
cmovle S2, P3
