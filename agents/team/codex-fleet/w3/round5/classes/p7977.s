# n=5 model=out iset=I1 prefix14_class=7977
cmp P1, P3
mov S1, P0
mov S2, P3
cmovge P3, P1
cmovl S2, P1
cmp S1, P2
cmovg S1, P2
cmovl P0, P2
mov S0, S1
cmp S2, S0
cmovge S0, S2
cmovle S1, S2
mov S1, P3
mov P1, S0
