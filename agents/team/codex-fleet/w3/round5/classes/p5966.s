# n=5 model=out iset=I1 prefix14_class=5966
cmp P1, P0
mov S1, P1
mov S0, P2
cmovle S1, P0
cmovl P0, P1
cmp S0, P3
cmovle S0, P3
cmovg P2, P3
cmovg P3, S0
cmp S0, S1
cmovl S0, S1
cmovg P3, S1
cmp P0, P2
cmovg S1, P3
