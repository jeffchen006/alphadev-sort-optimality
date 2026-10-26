# n=5 model=out iset=I1 prefix14_class=9666
mov S1, P1
cmp P2, P0
cmovle S2, P2
cmovg S2, P0
cmovl P2, P0
cmp P1, P3
cmovl P1, P3
cmovl P3, S1
cmp P1, P2
cmovg S0, P2
cmovg P2, P1
cmovg P1, S0
cmp P3, S2
cmovle S0, S2
