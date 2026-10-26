# n=5 model=out iset=I1 prefix14_class=11622
cmp P0, P2
mov S1, P0
mov S2, P3
cmovle S1, P2
cmovg P0, P2
cmp S2, P1
cmovle P3, P1
cmovl P1, S2
cmp P3, S1
cmovg S0, S1
cmovg S1, P3
cmovg P3, S0
mov S1, P1
cmp S1, P0
