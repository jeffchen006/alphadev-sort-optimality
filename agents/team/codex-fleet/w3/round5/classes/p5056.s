# n=5 model=out iset=I1 prefix14_class=5056
mov S2, P1
cmp P3, S2
cmovg S2, P3
mov S0, P2
cmovl P1, P3
cmp P0, S0
cmovl S0, P0
mov S1, S0
cmovg P2, P0
cmp P1, S0
cmovle S0, P1
cmovg S1, P1
cmp P2, S2
mov P3, S1
