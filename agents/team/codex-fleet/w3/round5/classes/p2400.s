# n=5 model=out iset=I1 prefix14_class=2400
cmp P3, P2
mov S2, P1
mov S1, P3
cmovg P3, P2
cmovle S1, P2
cmp P1, P0
cmovle S2, P0
cmovl P0, P1
cmp S1, S2
cmovg S0, S1
cmovle S0, S2
cmovl S2, S1
mov S0, P0
mov S1, S2
