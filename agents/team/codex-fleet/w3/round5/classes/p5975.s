# n=5 model=out iset=I1 prefix14_class=5975
cmp P0, P2
mov S0, P2
cmovle S0, P0
cmovg P2, P0
mov S1, P1
cmp P1, P3
cmovl S1, P3
cmovg P1, P3
mov P3, S1
cmp P2, P3
cmovl S1, P2
cmovl P2, P3
cmp P1, S0
cmovg S2, S0
