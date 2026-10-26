# n=5 model=out iset=I1 prefix14_class=9785
cmp P1, P2
mov S2, P1
cmovge P1, P2
cmovle S2, P2
mov S0, S2
cmp P3, P0
cmovle S1, P0
cmovge S1, P3
cmovl P0, P3
cmp S2, S1
cmovl S2, S1
cmovg S0, S1
cmp P0, P1
mov S2, S0
