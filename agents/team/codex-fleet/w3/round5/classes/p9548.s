# n=5 model=out iset=I1 prefix14_class=9548
cmp P0, P1
cmovge S0, P1
cmovg P1, P0
mov S2, P2
cmovge P0, S0
cmp P2, P3
cmovge P2, P3
cmovle S2, P3
cmp P2, P0
mov S1, P0
cmovl S1, P2
cmovl P2, P0
cmp S2, P1
mov P0, P1
