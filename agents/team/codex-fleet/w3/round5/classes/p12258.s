# n=5 model=out iset=I1 prefix14_class=12258
mov S1, P2
mov S0, P0
cmp P3, P0
cmovl S0, P3
cmovge P0, P3
cmp P1, P2
mov S2, S0
cmovge S1, P1
cmovg P1, P2
cmp S2, P1
cmovge S0, P1
cmovle S2, P1
cmp P0, S1
cmovg P1, S2
