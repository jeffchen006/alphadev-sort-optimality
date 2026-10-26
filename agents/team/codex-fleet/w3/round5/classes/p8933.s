# n=5 model=out iset=I1 prefix14_class=8933
mov S0, P1
cmp S0, P0
cmovle S0, P0
cmovge P1, P0
cmp P2, P3
cmovge P0, P3
cmovg P3, P2
mov S2, P3
cmovg P2, P0
cmp S0, P3
cmovl P3, S0
cmovl S0, S2
mov S1, P2
cmp P1, P2
