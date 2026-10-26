# n=5 model=out iset=I1 prefix14_class=14245
cmp P1, P0
cmovg S1, P0
mov S0, P3
cmovg P0, P1
cmovg P1, S1
cmp P2, S0
cmovl P3, P2
cmovg S0, P2
mov S2, S0
cmp P0, S2
cmovg S0, P0
cmovle S2, P0
mov S0, P1
cmp P3, P1
