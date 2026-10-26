# n=5 model=out iset=I1 prefix14_class=9751
mov S1, P0
cmp P0, P3
cmovg S1, P3
mov S2, S1
cmovg P3, P0
cmp P2, P1
cmovle P0, P1
cmovl P1, P2
cmovle P2, P0
cmp P2, P3
cmovle S0, P2
cmovg S0, P3
cmovg P3, P2
cmp S2, P1
