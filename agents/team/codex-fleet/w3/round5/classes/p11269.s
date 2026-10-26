# n=5 model=out iset=I1 prefix14_class=11269
mov S1, P1
cmp S1, P2
cmovl P1, P2
cmovg S1, P2
cmp P0, P3
cmovg S0, P3
cmovg P3, P0
cmovg P0, S0
cmp P1, P3
cmovg S2, P1
cmovle S2, P3
cmovg P1, P3
cmp P0, S1
cmovg P3, P0
