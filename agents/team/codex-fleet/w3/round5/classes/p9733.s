# n=5 model=out iset=I1 prefix14_class=9733
cmp P1, P2
mov S1, P2
cmovg P2, P1
cmovle S1, P1
mov S2, P0
cmp P0, P3
cmovl P0, P3
cmovle P3, S2
cmp P2, P0
cmovg P1, P2
cmovg P2, P0
mov S0, P3
cmovg P0, P1
cmp S0, S1
