# n=5 model=out iset=I1 prefix14_class=2088
mov S0, P0
cmp P2, P0
cmovle S0, P2
cmovge P0, P2
mov P2, P1
cmp P2, P3
cmovle P2, P3
cmovg P1, P3
cmp P0, P2
cmovge S2, P0
cmovl S2, P2
cmovg P0, P2
cmp S0, P1
cmovle P3, S0
