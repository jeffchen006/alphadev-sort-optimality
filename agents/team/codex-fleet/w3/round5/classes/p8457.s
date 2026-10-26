# n=5 model=out iset=I1 prefix14_class=8457
mov S2, P1
cmp P3, S2
cmovle S2, P3
mov S0, P2
cmovl P3, P1
mov P1, P3
cmp P2, P0
cmovl S0, P0
cmovge P2, P0
cmp S0, P1
cmovg P1, S0
cmovg S0, P3
cmp S2, P2
cmovge P0, P2
