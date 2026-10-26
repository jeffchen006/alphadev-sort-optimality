# n=5 model=out iset=I1 prefix14_class=12277
mov S2, P0
cmp P3, P0
cmovle S2, P3
cmovg P0, P3
cmp P2, P1
cmovge P3, P1
cmovg P1, P2
mov S0, S2
cmovg P2, P3
cmp S2, P2
cmovge S0, P2
cmovg P2, S2
cmp P1, P0
cmovl P3, P0
