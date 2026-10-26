# n=5 model=out iset=I1 prefix14_class=736
mov S2, P1
cmp P0, P2
cmovle S0, P0
cmovg S0, P2
cmovl P0, P2
cmp P1, P3
cmovg S2, P3
cmovl P1, P3
cmp P1, P0
cmovle S1, P1
cmovl P1, P0
cmovl P0, S1
mov S1, S2
cmp S2, S0
