# n=5 model=out iset=I1 prefix14_class=9898
mov S2, P1
cmp P3, P2
cmovge S1, P3
cmovge P3, P2
cmovg P2, S1
cmp P1, P0
cmovle S2, P0
mov S0, P2
cmovl P0, P1
cmp S2, P2
cmovl S0, S2
cmovl S2, P2
cmp P3, P0
mov S2, S0
