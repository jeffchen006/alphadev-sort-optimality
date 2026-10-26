# n=5 model=out iset=I1 prefix14_class=6928
mov S1, P1
cmp P0, P2
mov S0, P2
cmovg S0, P0
cmovge P0, P2
cmp S1, P3
cmovl P1, P3
cmovl P3, S1
cmp P1, S0
cmovl S2, S0
mov P2, P3
cmovle S0, P1
cmovl P1, S2
cmp P0, P2
