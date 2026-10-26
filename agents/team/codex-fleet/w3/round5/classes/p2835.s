# n=5 model=out iset=I1 prefix14_class=2835
cmp P2, P1
cmovge S2, P2
cmovle S2, P1
cmovge P2, P1
cmp P3, P0
mov P1, P0
cmovge P1, P3
cmovl P0, P3
mov S0, P1
cmp S0, S2
cmovl S0, S2
cmovl S2, P1
cmp P0, P2
cmovg P1, P2
