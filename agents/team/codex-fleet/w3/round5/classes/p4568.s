# n=5 model=out iset=I1 prefix14_class=4568
mov S0, P0
cmp P1, P0
cmovl S0, P1
cmovge P0, P1
cmp P2, P3
cmovge S1, P2
cmovge P2, P3
cmovle S1, P3
cmp P0, S1
mov S2, S1
cmovge S1, P0
cmovle S2, P0
cmp S0, P2
mov S1, S2
