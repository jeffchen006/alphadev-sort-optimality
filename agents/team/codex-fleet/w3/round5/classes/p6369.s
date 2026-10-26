# n=5 model=out iset=I1 prefix14_class=6369
mov S0, P3
cmp S0, P1
cmovge P3, P1
cmovg P1, S0
cmp P2, P0
mov S0, P0
cmovl S0, P2
cmovg P0, P2
mov P2, P1
cmp P0, P2
cmovl P1, P0
cmovg P2, P0
cmp P3, S0
cmovle S1, P3
