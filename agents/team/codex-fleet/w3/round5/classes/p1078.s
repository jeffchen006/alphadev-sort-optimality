# n=5 model=out iset=I1 prefix14_class=1078
cmp P1, P0
cmovg S2, P1
cmovle S2, P0
mov S0, P2
cmovl P0, P1
cmp S0, P3
cmovg S0, P3
cmovg P3, P2
cmp P3, S2
mov P2, S2
cmovl P2, P3
cmovge S2, P3
mov P3, S0
cmp P0, P3
