# n=5 model=out iset=I1 prefix14_class=13721
mov S0, P3
mov S1, P1
cmp P3, P0
cmovg P3, P0
cmovl S0, P0
cmp S1, P2
cmovle S1, P2
cmovge P1, P2
mov S2, S1
cmp S2, S0
cmovge S2, S0
cmovge S0, S1
cmp P3, P1
cmovg P0, P1
