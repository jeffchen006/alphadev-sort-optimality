# n=5 model=out iset=I1 prefix14_class=6249
cmp P0, P2
mov S2, P1
mov S0, P2
cmovge S0, P0
cmovge P0, P2
cmp P3, S2
cmovg P1, P3
mov S1, S0
cmovl S2, P3
cmp P1, S1
cmovge S0, P1
cmovge P1, S1
cmp S2, P0
cmovle S1, P0
