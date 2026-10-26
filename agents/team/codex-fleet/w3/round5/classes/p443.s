# n=5 model=out iset=I1 prefix14_class=443
cmp P1, P0
cmovg S2, P1
cmovle S2, P0
mov S1, P3
cmovl P0, P1
cmp S1, P2
mov S0, P0
cmovge P3, P2
cmovg P2, S1
cmp P3, S0
cmovl S0, P3
cmovl P3, P0
mov S1, S2
mov P1, P3
