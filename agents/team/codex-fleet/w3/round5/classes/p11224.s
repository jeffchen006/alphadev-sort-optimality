# n=5 model=out iset=I1 prefix14_class=11224
mov S2, P0
mov S0, P1
cmp S2, P3
cmovl S2, P3
cmovg P0, P3
cmp P2, P1
cmovle S0, P2
cmovg P1, P2
cmp P1, S2
cmovle S1, P1
cmovle P1, S2
cmovge S1, S2
cmp S0, P0
cmovg P1, P0
