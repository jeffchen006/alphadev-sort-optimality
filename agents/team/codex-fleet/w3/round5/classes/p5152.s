# n=5 model=out iset=I1 prefix14_class=5152
cmp P2, P3
mov S0, P2
cmovl P2, P3
cmovle P3, S0
cmp P0, P1
cmovle S1, P1
cmovl P1, P0
mov S2, P3
cmovl P0, S1
cmp P3, P1
cmovg S2, P1
cmovg P1, P3
cmp P0, P2
cmovg P3, P2
