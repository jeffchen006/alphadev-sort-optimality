# n=5 model=out iset=I1 prefix14_class=7756
mov S2, P3
cmp S2, P1
cmovl P3, P1
cmovg S2, P1
mov S0, P0
cmp P0, P2
cmovge P0, P2
cmovl S0, P2
cmp S2, P0
cmovge P2, P0
cmovg P0, S2
cmovge S2, P2
cmp S0, P3
cmovle S1, P3
