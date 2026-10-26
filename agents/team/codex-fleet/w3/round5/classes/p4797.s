# n=5 model=out iset=I1 prefix14_class=4797
mov S2, P2
cmp P1, S2
cmovge P2, P1
cmovle S2, P1
cmp P3, P0
mov S1, P3
cmovg P3, P0
cmovge P0, S1
cmp S2, P3
cmovge S0, S2
cmovl S0, P3
cmovl P3, S2
cmp P2, P0
cmovle S2, P0
