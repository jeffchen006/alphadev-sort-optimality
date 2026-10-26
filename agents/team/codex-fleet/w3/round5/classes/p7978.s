# n=5 model=out iset=I1 prefix14_class=7978
cmp P2, P3
cmovge S2, P3
cmovg P3, P2
cmovle S2, P2
cmp P1, P0
cmovge S1, P1
cmovg P1, P0
cmovl S1, P0
cmp S2, P1
mov S0, P1
cmovl S0, S2
cmovge P1, S2
cmp S1, P3
cmovge S0, P3
