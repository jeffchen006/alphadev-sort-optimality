# n=5 model=out iset=I1 prefix14_class=236
cmp P2, P0
cmovge S2, P2
mov S0, P3
cmovle S2, P0
cmovle P0, P2
cmp P3, P1
mov P2, P0
cmovge S0, P1
cmovg P1, P3
cmp S0, P2
cmovg P2, S0
cmovle P0, S0
cmovl S0, P2
mov P0, S2
