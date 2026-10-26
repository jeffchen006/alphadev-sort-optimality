# n=5 model=out iset=I1 prefix14_class=7700
cmp P0, P1
mov S2, P1
cmovg P1, P0
mov S0, P3
cmovl S2, P0
cmp S0, P2
cmovg P3, P2
cmovge P2, S0
cmp P3, S2
mov P0, P3
cmovl P3, S2
cmovg P0, S2
cmp P2, P1
cmovle S0, P2
