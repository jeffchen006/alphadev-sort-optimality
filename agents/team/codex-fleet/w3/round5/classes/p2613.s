# n=5 model=out iset=I1 prefix14_class=2613
cmp P3, P2
cmovg S2, P2
cmovg P2, P3
cmovg P3, S2
cmp P0, P1
cmovle S0, P1
mov S1, P2
cmovg S0, P0
cmovg P0, P1
cmp S0, P2
cmovle S1, S0
cmovle S0, P2
cmovl P2, S1
cmp P3, P0
