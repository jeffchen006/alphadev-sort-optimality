# n=5 model=out iset=I1 prefix14_class=9104
mov S1, P0
cmp S1, P3
mov S2, P2
cmovg S1, P3
cmovl P0, P3
cmp P2, P1
cmovl P2, P1
cmovge S2, P1
mov S0, S2
cmp S2, S1
cmovle S2, S1
cmovl S1, S0
cmp P0, P2
cmovge S0, P2
