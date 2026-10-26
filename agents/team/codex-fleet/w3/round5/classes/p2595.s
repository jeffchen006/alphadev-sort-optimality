# n=5 model=out iset=I1 prefix14_class=2595
cmp P3, P1
cmovge S0, P1
cmovg P1, P3
cmovg P3, S0
mov S2, P2
cmp S2, P0
cmovg P2, P0
cmovl S2, P0
mov S1, S2
cmp S2, P1
cmovg S1, P1
cmovle S2, P1
cmp P3, P2
mov S2, P2
