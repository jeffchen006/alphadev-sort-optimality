# n=5 model=out iset=I1 prefix14_class=78
cmp P1, P3
mov S2, P0
cmovle S0, P3
cmovge S0, P1
cmovge P1, P3
cmp P2, S2
cmovg S2, P2
cmovl P0, P2
mov P2, P0
cmp P0, P1
cmovge P0, P1
cmovg P1, P2
mov P3, S2
cmp S2, S0
