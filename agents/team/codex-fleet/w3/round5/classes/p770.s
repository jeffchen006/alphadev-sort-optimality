# n=5 model=out iset=I1 prefix14_class=770
cmp P3, P0
mov S2, P1
mov S1, P0
cmovle S1, P3
cmovl P3, P0
cmp P1, P2
mov P0, S1
cmovg P1, P2
cmovl S2, P2
cmp P3, S2
cmovg S0, P3
cmovle S0, S2
cmovle S2, P3
mov S0, S2
