# n=5 model=out iset=I1 prefix14_class=6433
mov S0, P3
cmp P2, P3
cmovg P3, P2
mov S2, P0
cmovl S0, P2
cmp P1, P0
mov S1, P3
cmovg P0, P1
cmovle S2, P1
cmp P0, P3
cmovg S1, P0
cmovl P3, P0
cmp S0, S2
cmovl P0, S2
