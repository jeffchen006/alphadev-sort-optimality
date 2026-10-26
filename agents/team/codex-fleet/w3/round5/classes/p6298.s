# n=5 model=out iset=I1 prefix14_class=6298
mov S1, P3
cmp P0, S1
cmovge P3, P0
cmovl S1, P0
mov S2, P2
cmp P2, P1
cmovge P2, P1
cmovg P1, S2
cmp P1, P3
cmovge S0, P3
cmovg P3, P1
mov S2, S1
cmovge P1, S0
cmp S2, P2
