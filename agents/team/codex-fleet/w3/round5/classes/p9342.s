# n=5 model=out iset=I1 prefix14_class=9342
cmp P2, P3
mov S0, P3
mov S2, P1
cmovle P3, P2
cmovl P2, S0
cmp P0, P1
cmovle S2, P0
cmovl P0, P1
cmp S2, P3
cmovg S1, P3
cmovg P3, S2
cmovg S2, S1
mov P1, P0
cmp P2, P1
