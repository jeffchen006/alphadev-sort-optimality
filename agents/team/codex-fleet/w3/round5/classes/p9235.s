# n=5 model=out iset=I1 prefix14_class=9235
cmp P2, P1
cmovg S2, P1
mov S0, P3
cmovg P1, P2
cmovle S2, P2
cmp P0, S0
mov P2, S2
cmovg S0, P0
cmovl P3, P0
cmp S2, P3
cmovle S2, P3
cmovl P3, P2
cmp S0, P1
cmovg P2, S2
