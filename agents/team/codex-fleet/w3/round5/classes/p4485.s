# n=5 model=out iset=I1 prefix14_class=4485
cmp P1, P2
cmovg S2, P1
cmovg P1, P2
cmovle S2, P2
cmp P3, P0
cmovle S0, P3
cmovl P3, P0
cmovg S0, P0
cmp P3, S2
cmovg P0, P3
cmovg P3, S2
cmovg S2, P0
cmp S0, P1
cmovg S2, S0
