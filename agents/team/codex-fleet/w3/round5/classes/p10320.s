# n=5 model=out iset=I1 prefix14_class=10320
cmp P1, P3
mov S0, P2
cmovle S1, P3
cmovle P3, P1
cmovge S1, P1
cmp P0, S0
cmovge P2, P0
cmovl S0, P0
cmp P2, S1
cmovg P0, S1
cmovge S1, P2
cmovg P2, P0
cmp S0, P3
cmovge S1, S0
