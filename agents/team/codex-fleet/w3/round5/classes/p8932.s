# n=5 model=out iset=I1 prefix14_class=8932
mov S0, P1
cmp S0, P0
cmovle S0, P0
cmovge P1, P0
cmp P3, P2
cmovge P0, P2
cmovg P2, P3
mov S2, P2
cmovg P3, P0
cmp S0, P2
cmovl P2, S0
cmovl S0, S2
mov S1, P3
cmp P1, P3
