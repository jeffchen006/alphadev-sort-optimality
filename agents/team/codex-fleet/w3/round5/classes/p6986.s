# n=5 model=out iset=I1 prefix14_class=6986
mov S2, P0
cmp P3, P1
mov S0, P1
cmovge P1, P3
cmovle S0, P3
cmp P2, P0
cmovl S2, P2
cmovl P2, P0
mov P0, S2
cmp S0, P0
cmovl P0, S0
cmovle S0, S2
cmp P2, P1
mov P0, S0
