# n=5 model=out iset=I1 prefix14_class=7654
mov S1, P3
mov S2, P0
cmp P2, S2
cmovg P0, P2
cmovl S2, P2
cmovg P2, S2
cmp P1, P3
cmovl P3, P1
cmovg S1, P1
cmp P3, S2
cmovg S2, P3
cmovl P2, P3
cmp S1, P0
cmovle S0, S1
