# n=5 model=out iset=I1 prefix14_class=9647
mov S2, P1
cmp P2, S2
cmovl P1, P2
mov S1, P0
cmovge S2, P2
cmp S1, P3
cmovl S1, P3
cmovg P0, P3
cmp S2, S1
cmovle S0, S1
cmovle S1, S2
cmovg S0, S2
cmp P1, P0
cmovge P2, P1
