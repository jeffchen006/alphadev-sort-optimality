# n=5 model=out iset=I1 prefix14_class=4165
mov S1, P1
cmp P0, P2
mov S2, P2
cmovg P2, P0
cmovle S2, P0
cmp P1, P3
cmovl P1, P3
mov S0, S2
cmovl P3, S1
cmp P3, S0
cmovg S0, P3
cmovle S2, P3
cmp P1, P2
mov S2, S0
